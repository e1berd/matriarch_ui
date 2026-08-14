defmodule MatriarchUIDocsWeb.Examples.Chat do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  use Phoenix.VerifiedRoutes,
    endpoint: MatriarchUIDocsWeb.Endpoint,
    router: MatriarchUIDocsWeb.Router

  def search_content(_locale) do
    "LiveView stream PubSub Presence bounded message window infinite scroll deep links typing LLM assistant rich editor tiptap"
  end

  attr :streams, :map, required: true
  attr :form, :any, required: true
  attr :message_value, :string, required: true
  attr :identity, :map, required: true
  attr :typing, :list, required: true
  attr :typing_label, :string, default: nil
  attr :online_count, :integer, required: true
  attr :limit, :integer, required: true
  attr :offset, :integer, required: true
  attr :target_message_id, :string, default: nil
  attr :has_older, :boolean, required: true
  attr :has_newer, :boolean, required: true
  attr :locale, :string, required: true

  def examples(assigns) do
    ~H"""
    <div class="flex flex-col gap-8">
      <.example
        locale={@locale}
        title="LiveView stream + PubSub"
        description="Open this page in another browser window: messages and typing state are shared in real time without Postgres. The composer is a MatriarchUI.RichEditor, composed at the call site rather than baked into the chat primitives."
        class="block p-0"
        code={
          ~S'''
          <.chat id="phoenix-chat" class="h-[38rem] w-full">
            <.chat_header>
              <.avatar initials="LV" size="md" />
              <div class="min-w-0">
                <.chat_header_title>Phoenix commons</.chat_header_title>
                <.chat_presence state="online" label={"#{@online_count} online"} />
              </div>
            </.chat_header>

            <.chat_messages
              id="phoenix-chat-messages"
              messages_limit={@limit}
              messages_offset={@offset}
              target_message_id={@target_message_id}
              has_older={@has_older}
              has_newer={@has_newer}
            >
              <.chat_message
                :for={{dom_id, message} <- @streams.messages}
                id={dom_id}
                message_id={message.id}
                side={if message.author_id == @identity.id, do: "outgoing", else: "incoming"}
                author_kind={message.author_kind}
                author={message.author_name}
                focused={message.id == @target_message_id}
              >
                <:meta>
                  <.link
                    patch={message_path(message.id, @limit, @offset, @locale)}
                    class="hover:text-mui-primary"
                  >
                    {message.inserted_at}
                  </.link>
                </:meta>
                <:avatar :if={message.author_id != @identity.id}>
                  <.avatar initials={initials(message.author_name)} size="sm" />
                </:avatar>
                <:content>{message.body}</:content>
              </.chat_message>
            </.chat_messages>

            <.chat_typing_indicator :if={@typing != []} label={@typing_label} />

            <.chat_composer
              id="phoenix-chat-composer"
              for={@form}
              phx-change="chat:typing"
              phx-submit="chat:send"
            >
              <.rich_editor
                id="phoenix-chat-input"
                editable
                placeholder="Write a message…"
                class="min-h-8 flex-1 border-0 bg-transparent shadow-none"
              >
                <:toolbar class="hidden"></:toolbar>
                <:content class="min-h-0 flex-1 [&_.mui-rich-editor-content]:min-h-0 [&_.mui-rich-editor-content]:px-2 [&_.mui-rich-editor-content]:py-1.5" />
              </.rich_editor>
              <input
                type="text"
                class="hidden"
                name="chat[message]"
                id="phoenix-chat-input-plain"
                phx-hook=".ChatRichBridge"
                data-mui-chat-bridge-for="phoenix-chat-input"
              />
              <.button type="submit" variant="brand" size="icon" aria-label="Send message">
                <.icon name="paper-plane-tilt" />
              </.button>
            </.chat_composer>
          </.chat>
          '''
        }
      >
        <.chat id="phoenix-chat" class="h-[38rem] w-full">
          <.chat_header>
            <.avatar initials="LV" size="md" />
            <div class="min-w-0">
              <.chat_header_title>Phoenix commons</.chat_header_title>
              <.chat_presence state="online" label={"#{@online_count} online"} />
            </div>
          </.chat_header>

          <.chat_messages
            id="phoenix-chat-messages"
            messages_limit={@limit}
            messages_offset={@offset}
            target_message_id={@target_message_id}
            has_older={@has_older}
            has_newer={@has_newer}
          >
            <.chat_message
              :for={{dom_id, message} <- @streams.messages}
              id={dom_id}
              message_id={message.id}
              side={if message.author_id == @identity.id, do: "outgoing", else: "incoming"}
              author_kind={message.author_kind}
              author={message.author_name}
              focused={message.id == @target_message_id}
            >
              <:meta>
                <.link
                  patch={message_path(message.id, @limit, @offset, @locale)}
                  class="hover:text-mui-primary"
                >
                  {message.inserted_at}
                </.link>
              </:meta>
              <:avatar :if={message.author_id != @identity.id}>
                <.avatar initials={initials(message.author_name)} size="sm" />
              </:avatar>
              <:content>{message.body}</:content>
            </.chat_message>
          </.chat_messages>

          <.chat_typing_indicator :if={@typing != []} label={@typing_label} />

          <.chat_composer
            id="phoenix-chat-composer"
            for={@form}
            phx-change="chat:typing"
            phx-submit="chat:send"
          >
            <.rich_editor
              id="phoenix-chat-input"
              editable
              placeholder="Write a message…"
              class="min-h-8 flex-1 border-0 bg-transparent shadow-none"
            >
              <:toolbar class="hidden"></:toolbar>
              <:content class="min-h-0 flex-1 [&_.mui-rich-editor-content]:min-h-0 [&_.mui-rich-editor-content]:px-2 [&_.mui-rich-editor-content]:py-1.5" />
            </.rich_editor>
            <input
              type="text"
              class="hidden"
              name="chat[message]"
              id="phoenix-chat-input-plain"
              phx-hook=".ChatRichBridge"
              data-mui-chat-bridge-for="phoenix-chat-input"
            />
            <.button type="submit" variant="brand" size="icon" aria-label="Send message">
              <.icon name="paper-plane-tilt" />
            </.button>
          </.chat_composer>
        </.chat>
      </.example>

      <section class="grid gap-3 md:grid-cols-3">
        <.architecture_card title="UI primitives">
          Header, presence, viewport, message, bubble, typing indicator, and composer can be rearranged or replaced independently.
        </.architecture_card>
        <.architecture_card title="Window contract">
          The LiveView owns chat_limit and chat_offset. The hook emits load events and preserves a shared message as the visual anchor.
        </.architecture_card>
        <.architecture_card title="Transport agnostic">
          A message's <code>:content</code>
          slot accepts plain text or rendered rich DOM. This demo bridges the rich editor's Tiptap document to a plain-text field — PubSub, database queries, and any richer storage stay in the host application.
        </.architecture_card>
      </section>

      <.props_table
        locale={@locale}
        rows={[
          {"chat_messages.id", "string, required",
           "unique DOM id for the scroll and virtualization hooks"},
          {"messages_limit", "integer", "maximum normal window size; defaults to 64"},
          {"messages_offset", "integer",
           "server-side offset represented by the current stream window"},
          {"target_message_id", "string | nil",
           "deep-linked message focused after an initial bottom position"},
          {"has_older / has_newer", "boolean", "enables the corresponding infinite-scroll edge"},
          {"load_older / load_newer", "string", "LiveView events that move the query window"},
          {"chat_message.message_id", "string, required",
           "stable application id used for anchors and links"},
          {"chat_message.author_kind", "person | assistant | system",
           "identifies human, LLM, and system authors without prescribing a schema"},
          {"chat_message.:content", "slot",
           "plain text or rich DOM; the bubble variant is derived from side/author_kind"},
          {"chat_message.:inner_block", "slot",
           "drop down to a manual <.chat_bubble> for full control instead of :content"},
          {"chat_composer.submit_on_enter", "boolean",
           "Enter submits; Shift+Enter inserts a line break — also works inside a nested .rich_editor"},
          {"chat_composer.clear_on_submit", "boolean",
           "clears text fields and any nested .rich_editor after a successful submit"}
        ]}
      />

      <MatriarchUIDocsWeb.Examples.ChatPresenceGuide.guide />
    </div>

    <script :type={Phoenix.LiveView.ColocatedHook} name=".ChatRichBridge">
      function plainText(doc) {
        const lines = []

        const walk = (node, into) => {
          if (node.type === "text") {
            into.push(node.text || "")
            return
          }

          const blockTypes = ["paragraph", "heading", "listItem", "taskItem", "blockquote", "codeBlock"]
          const isBlock = blockTypes.includes(node.type)
          const parts = isBlock ? [] : into
          ;(node.content || []).forEach((child) => walk(child, parts))
          if (isBlock) lines.push(parts.join(""))
        }

        ;(doc.content || []).forEach((node) => walk(node, []))
        return lines.join("\n").trim()
      }

      export default {
        mounted() {
          const richEditor = document.getElementById(this.el.dataset.muiChatBridgeFor)
          if (!richEditor) return

          this.onChange = (event) => {
            this.el.value = plainText(event.detail.json)
            this.el.dispatchEvent(new Event("input", { bubbles: true }))
          }

          richEditor.addEventListener("mui:rich-editor-change", this.onChange)
        },
        destroyed() {
          document
            .getElementById(this.el.dataset.muiChatBridgeFor)
            ?.removeEventListener("mui:rich-editor-change", this.onChange)
        },
      }
    </script>
    """
  end

  attr :title, :string, required: true
  slot :inner_block, required: true

  defp architecture_card(assigns) do
    ~H"""
    <div class="rounded-mui-lg border border-mui-border bg-mui-surface p-4 shadow-mui-xs">
      <h3 class="text-sm font-semibold text-mui-foreground">{@title}</h3>
      <p class="mt-1 text-sm leading-6 text-mui-muted-foreground">{render_slot(@inner_block)}</p>
    </div>
    """
  end

  defp initials(name) do
    name
    |> String.split()
    |> Enum.take(2)
    |> Enum.map_join(&String.first/1)
  end

  defp message_path(message_id, limit, offset, "ru") do
    ~p"/docs/components/chat?#{[chat_message: message_id, chat_limit: limit, chat_offset: offset, locale: "ru"]}"
  end

  defp message_path(message_id, limit, offset, _locale) do
    ~p"/docs/components/chat?#{[chat_message: message_id, chat_limit: limit, chat_offset: offset]}"
  end
end
