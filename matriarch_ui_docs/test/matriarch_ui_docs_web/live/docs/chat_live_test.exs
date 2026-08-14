defmodule MatriarchUIDocsWeb.Docs.ChatLiveTest do
  use MatriarchUIDocsWeb.ConnCase, async: false
  import Phoenix.LiveViewTest
  alias MatriarchUIDocs.ChatStore

  test "renders only the latest bounded message window", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/docs/components/chat")

    assert has_element?(view, "#phoenix-chat")
    assert message_count(view) == 64

    assert has_element?(
             view,
             "#phoenix-chat-messages-stream[data-messages-limit='64'][data-has-older='true'][data-has-newer='false']"
           )
  end

  test "scroll events move limit and offset into the query string", %{conn: conn} do
    latest = ChatStore.window(64, 1_000_000)
    {:ok, view, _html} = live(conn, ~p"/docs/components/chat")

    render_hook(view, "chat:load-older", %{})

    expected_offset = max(latest.offset - 32, 0)

    assert_patch(
      view,
      ~p"/docs/components/chat?#{[chat_limit: 64, chat_offset: expected_offset]}"
    )

    assert message_count(view) == 64
  end

  test "scrolling back down advances an older window", %{conn: conn} do
    {:ok, view, _html} =
      live(conn, ~p"/docs/components/chat?#{[chat_limit: 64, chat_offset: 0]}")

    render_hook(view, "chat:load-newer", %{})

    assert_patch(view, ~p"/docs/components/chat?#{[chat_limit: 64, chat_offset: 32]}")
    assert message_count(view) == 64
  end

  test "a message link loads 64 messages on either side and marks its target", %{conn: conn} do
    path =
      ~p"/docs/components/chat?#{[chat_message: "message-90", chat_limit: 64, chat_offset: 0]}"

    {:ok, view, _html} = live(conn, path)

    assert message_count(view) == 129

    assert has_element?(
             view,
             "#chat-message-message-90[data-message-id='message-90'][aria-current='true']"
           )

    assert has_element?(
             view,
             "#phoenix-chat-messages-stream[data-target-message-id='message-90']"
           )
  end

  test "PubSub delivers submitted messages to another connected visitor", %{conn: conn} do
    {:ok, first, _html} = live(conn, ~p"/docs/components/chat")
    {:ok, second, _html} = live(conn, ~p"/docs/components/chat")
    body = "Shared without Postgres #{System.unique_integer([:positive])}"

    first
    |> form("#phoenix-chat-composer", chat: %{message: body})
    |> render_submit()

    assert eventually(fn -> render(second) =~ body end)
    assert message_count(second) == 64
  end

  test "sending from history returns the sender to the latest window", %{conn: conn} do
    {:ok, view, _html} =
      live(conn, ~p"/docs/components/chat?#{[chat_limit: 64, chat_offset: 0]}")

    body = "Return to latest #{System.unique_integer([:positive])}"

    view
    |> form("#phoenix-chat-composer", chat: %{message: body})
    |> render_submit()

    assert_patch(view, ~p"/docs/components/chat")

    assert eventually(fn -> render(view) =~ body end)
  end

  test "the latest window has a canonical query-free URL", %{conn: conn} do
    latest = ChatStore.window(64, 1_000_000_000)
    previous_offset = max(latest.offset - 32, 0)

    {:ok, view, _html} =
      live(
        conn,
        ~p"/docs/components/chat?#{[chat_limit: 64, chat_offset: previous_offset]}"
      )

    render_hook(view, "chat:load-newer", %{})

    assert_patch(view, ~p"/docs/components/chat")
    assert has_element?(view, "#phoenix-chat-messages-stream[data-has-newer='false']")
  end

  test "a session message remains reachable after scrolling to history and back", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/docs/components/chat")
    body = "Session tail #{System.unique_integer([:positive])}"

    view
    |> form("#phoenix-chat-composer", chat: %{message: body})
    |> render_submit()

    assert eventually(fn -> render(view) =~ body end)

    render_hook(view, "chat:load-older", %{})
    refute render(view) =~ body

    render_hook(view, "chat:load-newer", %{})
    assert eventually(fn -> render(view) =~ body end)
  end

  test "documents Phoenix Presence online indicators without PostgreSQL", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/docs/components/chat")

    assert has_element?(view, "#chat-presence-guide")
    assert render(view) =~ "use Phoenix.Presence"
    assert render(view) =~ "PostgreSQL is not required"
    assert render(view) =~ "presence_diff"
  end

  test "Presence shares typing state between visitors", %{conn: conn} do
    {:ok, first, _html} = live(conn, ~p"/docs/components/chat")
    {:ok, second, _html} = live(conn, ~p"/docs/components/chat")

    first
    |> form("#phoenix-chat-composer", chat: %{message: "typing now"})
    |> render_change()

    assert eventually(fn -> has_element?(second, "[data-mui-chat-typing][role='status']") end)
  end

  defp message_count(view) do
    view
    |> render()
    |> LazyHTML.from_fragment()
    |> LazyHTML.query("#phoenix-chat-messages-stream > [data-mui-chat-message]")
    |> Enum.count()
  end

  defp eventually(fun, attempts \\ 30)
  defp eventually(_fun, 0), do: false

  defp eventually(fun, attempts) do
    if fun.() do
      true
    else
      Process.sleep(10)
      eventually(fun, attempts - 1)
    end
  end
end
