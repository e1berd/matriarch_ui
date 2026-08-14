defmodule MatriarchUIDocsWeb.Docs.ChatLive do
  use MatriarchUIDocsWeb, :live_view
  alias MatriarchUI.I18n
  alias MatriarchUIDocs.ChatStore
  alias MatriarchUIDocsWeb.{ChatPresence, DocsSidebar, Registry}
  alias MatriarchUIDocsWeb.Examples.Chat, as: ChatExample

  @default_limit 64

  def mount(params, _session, socket) do
    locale = I18n.normalize_locale(params["locale"])
    identity = ChatPresence.identity(socket)
    presence = ChatPresence.track(socket, identity)

    if connected?(socket) do
      Phoenix.PubSub.subscribe(MatriarchUIDocs.PubSub, ChatStore.message_topic())
    end

    socket =
      socket
      |> stream_configure(:messages, dom_id: &"chat-message-#{&1.id}")
      |> stream(:messages, [])
      |> assign(
        page_title: Registry.fetch("chat", locale).title,
        locale: locale,
        language_paths: language_paths(params),
        identity: identity,
        online_count: presence.online_count,
        typing: presence.typing,
        typing_timer: nil,
        form: empty_form(),
        message_value: "",
        limit: @default_limit,
        offset: 0,
        total: 0,
        target_message_id: nil,
        has_older: false,
        has_newer: false,
        window_messages: []
      )

    {:ok, socket}
  end

  def render(assigns) do
    assigns = assign(assigns, :typing_label, typing_label(assigns.typing, assigns.locale))

    ~H"""
    <Layouts.app flash={@flash} locale={@locale} language_paths={@language_paths}>
      <div class="mx-auto flex max-w-6xl gap-2 px-6">
        <DocsSidebar.sidebar active="chat" locale={@locale} />
        <div class="min-w-0 flex-1 border-l border-mui-border py-8 pl-7">
          <div class="mb-6">
            <p class="text-xs font-semibold uppercase tracking-wide text-mui-accent">
              Phoenix LiveView
            </p>
            <h1 class="mt-1 text-2xl font-semibold tracking-tight text-mui-foreground">
              {@page_title}
            </h1>
            <p class="mt-2 max-w-3xl text-sm leading-6 text-mui-muted-foreground">
              A bounded stream window with anchored infinite scroll, message deep-links, Presence typing state, and ephemeral PubSub delivery. This demo intentionally uses no database.
            </p>
          </div>
          <ChatExample.examples
            streams={@streams}
            form={@form}
            message_value={@message_value}
            identity={@identity}
            typing={@typing}
            typing_label={@typing_label}
            online_count={@online_count}
            limit={@limit}
            offset={@offset}
            target_message_id={@target_message_id}
            has_older={@has_older}
            has_newer={@has_newer}
            locale={@locale}
          />
        </div>
      </div>
    </Layouts.app>
    """
  end

  def handle_params(params, _uri, socket) do
    locale = I18n.normalize_locale(params["locale"])

    limit =
      params
      |> Map.get("chat_limit", Integer.to_string(@default_limit))
      |> parse_integer(@default_limit, 16, 128)

    target_message_id = present_value(params["chat_message"])

    window =
      if target_message_id do
        ChatStore.around(target_message_id, limit)
      else
        offset = parse_offset(params["chat_offset"])
        ChatStore.window(limit, offset)
      end

    socket =
      socket
      |> stream(:messages, window.messages, reset: true)
      |> assign(
        page_title: Registry.fetch("chat", locale).title,
        locale: locale,
        language_paths: language_paths(params),
        limit: limit,
        offset: window.offset,
        total: window.total,
        target_message_id: Map.get(window, :target),
        has_older: window.has_older,
        has_newer: window.has_newer,
        window_messages: window.messages
      )

    {:noreply, socket}
  end

  def handle_event("chat:load-older", _params, socket) do
    offset = max(socket.assigns.offset - window_step(socket.assigns.limit), 0)

    {:noreply,
     push_patch(socket, to: chat_path(socket.assigns.locale, socket.assigns.limit, offset))}
  end

  def handle_event("chat:load-newer", _params, socket) do
    latest_offset = max(socket.assigns.total - socket.assigns.limit, 0)
    offset = min(socket.assigns.offset + window_step(socket.assigns.limit), latest_offset)

    path =
      if offset == latest_offset do
        latest_chat_path(socket.assigns.locale)
      else
        chat_path(socket.assigns.locale, socket.assigns.limit, offset)
      end

    {:noreply, push_patch(socket, to: path)}
  end

  def handle_event("chat:typing", %{"chat" => %{"message" => body}}, socket) do
    typing? = String.trim(body) != ""
    socket = socket |> update_typing(typing?) |> assign(message_value: body)
    {:noreply, socket}
  end

  def handle_event("chat:send", %{"chat" => %{"message" => body}}, socket) do
    body = String.trim(body)

    if body == "" do
      {:noreply, socket}
    else
      ChatStore.append(%{
        author_id: socket.assigns.identity.id,
        author_name: socket.assigns.identity.name,
        author_kind: socket.assigns.identity.kind,
        body: body
      })

      socket = socket |> update_typing(false) |> assign(form: empty_form(), message_value: "")

      if socket.assigns.has_newer || socket.assigns.target_message_id do
        {:noreply, push_patch(socket, to: latest_chat_path(socket.assigns.locale))}
      else
        {:noreply, socket}
      end
    end
  end

  def handle_info({:chat_message, message}, socket) do
    cond do
      Enum.any?(socket.assigns.window_messages, &(&1.id == message.id)) ->
        {:noreply, socket}

      !socket.assigns.has_newer && is_nil(socket.assigns.target_message_id) ->
        {socket, messages, offset} = append_to_window(socket, message)

        {:noreply,
         assign(socket,
           window_messages: messages,
           offset: offset,
           total: socket.assigns.total + 1
         )}

      true ->
        {:noreply, assign(socket, total: socket.assigns.total + 1, has_newer: true)}
    end
  end

  def handle_info(:typing_timeout, socket) do
    {:noreply, update_typing(socket, false)}
  end

  def handle_info(message, socket) do
    if ChatPresence.diff?(message) do
      presence = ChatPresence.snapshot(socket.assigns.identity.id)
      {:noreply, assign(socket, online_count: presence.online_count, typing: presence.typing)}
    else
      {:noreply, socket}
    end
  end

  defp append_to_window(socket, message) do
    messages = socket.assigns.window_messages
    full? = length(messages) >= socket.assigns.limit
    socket = stream_insert(socket, :messages, message)

    socket =
      if full? do
        stream_delete(socket, :messages, List.first(messages))
      else
        socket
      end

    messages = Enum.take(messages ++ [message], -socket.assigns.limit)
    offset = if full?, do: socket.assigns.offset + 1, else: socket.assigns.offset
    {socket, messages, offset}
  end

  defp update_typing(socket, typing?) do
    if socket.assigns.typing_timer, do: Process.cancel_timer(socket.assigns.typing_timer)
    ChatPresence.set_typing(socket.assigns.identity, typing?)

    timer =
      if typing? do
        Process.send_after(self(), :typing_timeout, 2_500)
      end

    assign(socket, typing_timer: timer)
  end

  defp typing_label([], _locale), do: nil

  defp typing_label(participants, "ru") do
    names = Enum.map_join(participants, ", ", & &1.name)
    "#{names} печатает…"
  end

  defp typing_label(participants, _locale) do
    names = Enum.map_join(participants, ", ", & &1.name)
    "#{names} #{if length(participants) == 1, do: "is", else: "are"} typing…"
  end

  defp empty_form, do: to_form(%{"message" => ""}, as: :chat)

  defp window_step(limit), do: max(div(limit, 2), 1)

  defp parse_offset(nil), do: 1_000_000_000
  defp parse_offset(value), do: parse_integer(value, 0, 0, 1_000_000_000)

  defp parse_integer(value, fallback, minimum, maximum) do
    case Integer.parse(value) do
      {number, ""} -> number |> max(minimum) |> min(maximum)
      _ -> fallback
    end
  end

  defp present_value(value) when value in [nil, ""], do: nil
  defp present_value(value), do: value

  defp chat_path("ru", limit, offset),
    do: ~p"/docs/components/chat?#{[chat_limit: limit, chat_offset: offset, locale: "ru"]}"

  defp chat_path(_locale, limit, offset),
    do: ~p"/docs/components/chat?#{[chat_limit: limit, chat_offset: offset]}"

  defp latest_chat_path("ru"), do: ~p"/docs/components/chat?#{[locale: "ru"]}"
  defp latest_chat_path(_locale), do: ~p"/docs/components/chat"

  defp language_paths(params) do
    params = Map.drop(params, ["locale"])

    %{
      "en" => ~p"/docs/components/chat?#{params}",
      "ru" => ~p"/docs/components/chat?#{Map.put(params, "locale", "ru")}"
    }
  end
end
