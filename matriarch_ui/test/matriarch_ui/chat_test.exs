defmodule MatriarchUI.ChatTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest
  import MatriarchUI.Chat
  import MatriarchUI.ChatMessages

  defp document(html), do: LazyHTML.from_fragment(html)

  test "chat renders a named composable conversation region" do
    html =
      render_component(&chat/1, %{
        id: "support-chat",
        rest: %{"aria-label" => "Support conversation"},
        inner_block: [%{inner_block: fn _, _ -> "Conversation" end}]
      })

    assert document(html)
           |> LazyHTML.query("#support-chat[data-mui-chat][aria-label='Support conversation']")
           |> Enum.any?()
  end

  test "header exposes identity, presence, and actions as separate primitives" do
    html =
      render_component(&chat_header/1, %{
        inner_block: [%{inner_block: fn _, _ -> "Ada Lovelace" end}],
        actions: [%{inner_block: fn _, _ -> "Call" end}]
      })

    presence = render_component(&chat_presence/1, %{state: "online", label: "Online"})

    assert document(html) |> LazyHTML.query("header") |> Enum.any?()

    assert document(presence)
           |> LazyHTML.query("[data-mui-chat-presence='online']")
           |> Enum.any?()
  end

  test "message carries stable deep-link and author semantics" do
    html =
      render_component(&chat_message/1, %{
        id: "messages-42",
        message_id: "42",
        author_kind: "assistant",
        author: "Matriarch AI",
        time: "12:40",
        focused: true,
        inner_block: [%{inner_block: fn _, _ -> "How can I help?" end}]
      })

    bubble =
      render_component(&chat_bubble/1, %{
        variant: "assistant",
        inner_block: [%{inner_block: fn _, _ -> "How can I help?" end}]
      })

    page = document(html)

    assert page
           |> LazyHTML.query(
             "#messages-42[data-message-id='42'][data-mui-author-kind='assistant'][aria-current='true']"
           )
           |> Enum.any?()

    assert document(bubble) |> LazyHTML.query("[data-mui-chat-bubble='assistant']") |> Enum.any?()
  end

  test "message derives its bubble variant from side and author_kind via :content" do
    html =
      render_component(&chat_message/1, %{
        id: "messages-7",
        message_id: "7",
        side: "outgoing",
        content: [%{inner_block: fn _, _ -> "On my way" end}]
      })

    assert document(html) |> LazyHTML.query("[data-mui-chat-bubble='outgoing']") |> Enum.any?()
    assert document(html) |> LazyHTML.query("[data-mui-chat-content]") |> Enum.any?()
  end

  test "message viewport publishes a bounded virtual window" do
    html =
      render_component(&chat_messages/1, %{
        id: "room-messages",
        messages_limit: 64,
        messages_offset: 128,
        target_message_id: "message-160",
        has_older: true,
        has_newer: true,
        inner_block: [%{inner_block: fn _, _ -> "Messages" end}]
      })

    page = document(html)

    assert page
           |> LazyHTML.query(
             "#room-messages-stream[phx-hook='MatriarchUI.ChatMessages.MUIChatMessages'][data-messages-limit='64'][data-messages-offset='128'][data-target-message-id='message-160']"
           )
           |> Enum.any?()

    assert page
           |> LazyHTML.query("#room-messages-stream[phx-update='stream'][role='log']")
           |> Enum.any?()

    assert page |> LazyHTML.query("[data-mui-chat-edge='older']") |> Enum.any?()
    assert page |> LazyHTML.query("[data-mui-chat-edge='newer']") |> Enum.any?()
  end

  test "typing indicator announces any consumer-provided participant label" do
    html =
      render_component(&chat_typing_indicator/1, %{label: "Ada, Lin, and Matriarch AI are typing"})

    page = document(html)

    assert page
           |> LazyHTML.query("[data-mui-chat-typing][role='status'][aria-live='polite']")
           |> Enum.any?()

    assert page
           |> LazyHTML.query("[data-mui-chat-typing] [aria-hidden='true'] > span")
           |> Enum.count() == 3
  end

  test "composer is a native Phoenix form with a stable id" do
    html =
      render_component(&chat_composer/1, %{
        id: "chat-composer",
        for: Phoenix.Component.to_form(%{"message" => ""}, as: :chat),
        rest: %{"phx-submit": "send-message"},
        inner_block: [%{inner_block: fn _, _ -> "Composer controls" end}]
      })

    assert document(html)
           |> LazyHTML.query(
             "#chat-composer[data-mui-chat-composer][data-submit-on-enter='true'][data-clear-on-submit='true'][phx-hook='MatriarchUI.Chat.MUIChatComposer'][phx-submit='send-message']"
           )
           |> Enum.any?()
  end

  test "message content is an independent rich-DOM boundary" do
    html =
      render_component(&chat_message_content/1, %{
        inner_block: [%{inner_block: fn _, _ -> "Rich content" end}]
      })

    assert document(html) |> LazyHTML.query("[data-mui-chat-content]") |> Enum.any?()
  end
end
