defmodule MatriarchUIDocsWeb.Examples.Chat do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  use Phoenix.VerifiedRoutes,
    endpoint: MatriarchUIDocsWeb.Endpoint,
    router: MatriarchUIDocsWeb.Router

  def search_content(_locale) do
    "LiveView stream PubSub Presence bounded message window infinite scroll deep links typing LLM assistant"
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
        description="Open this page in another browser window: messages and typing state are shared in real time without Postgres."
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
              <:actions>
                <.button variant="ghost" size="icon" aria-label="Conversation options">
                  <.icon name="dots-three" />
                </.button>
              </:actions>
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
                <.chat_bubble variant={bubble_variant(message, @identity.id)}>
                  <.chat_message_content>{message.body}</.chat_message_content>
                </.chat_bubble>
              </.chat_message>
            </.chat_messages>

            <.chat_typing_indicator :if={@typing != []} label={@typing_label} />

            <.chat_composer
              id="phoenix-chat-composer"
              for={@form}
              phx-change="chat:typing"
              phx-submit="chat:send"
            >
              <.textarea
                id="phoenix-chat-input"
                name="chat[message]"
                value={@message_value}
                rows="1"
                placeholder="Write a message…"
                class="min-h-8 resize-none border-0 bg-transparent px-2 py-1.5 shadow-none focus-visible:border-transparent focus-visible:ring-0"
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
            <:actions>
              <.button variant="ghost" size="icon" aria-label="Conversation options">
                <.icon name="dots-three" />
              </.button>
            </:actions>
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
              <.chat_bubble variant={bubble_variant(message, @identity.id)}>
                <.chat_message_content>{message.body}</.chat_message_content>
              </.chat_bubble>
            </.chat_message>
          </.chat_messages>

          <.chat_typing_indicator :if={@typing != []} label={@typing_label} />

          <.chat_composer
            id="phoenix-chat-composer"
            for={@form}
            phx-change="chat:typing"
            phx-submit="chat:send"
          >
            <.textarea
              id="phoenix-chat-input"
              name="chat[message]"
              value={@message_value}
              rows="1"
              placeholder="Write a message…"
              class="min-h-8 resize-none border-0 bg-transparent px-2 py-1.5 shadow-none focus-visible:border-transparent focus-visible:ring-0"
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
          The content primitive accepts plain text or rendered rich-text DOM. PubSub, database queries, Tiptap, and LLM pipelines stay in the host application.
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
          {"chat_message_content", "slot",
           "plain text or rich DOM rendered from a future editor document"},
          {"chat_composer.submit_on_enter", "boolean",
           "Enter submits; Shift+Enter inserts a line break"},
          {"chat_composer.clear_on_submit", "boolean",
           "clears native text fields after a successful form submit event"}
        ]}
      />

      <MatriarchUIDocsWeb.Examples.ChatPresenceGuide.guide />
    </div>
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

  defp bubble_variant(message, own_id) do
    cond do
      message.author_id == own_id -> "outgoing"
      message.author_kind == "assistant" -> "assistant"
      true -> "incoming"
    end
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
