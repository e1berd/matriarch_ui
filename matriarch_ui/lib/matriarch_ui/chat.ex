defmodule MatriarchUI.Chat do
  @moduledoc "Composable primitives for LiveView-native conversations."
  use Phoenix.Component
  alias MatriarchUI.CN

  attr :id, :string, required: true
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def chat(assigns) do
    ~H"""
    <section
      id={@id}
      data-mui
      data-mui-chat
      class={CN.cn(["flex min-h-0 flex-col overflow-hidden rounded-mui-xl border border-mui-card-border bg-mui-card text-mui-foreground shadow-mui-md", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </section>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true
  slot :actions

  def chat_header(assigns) do
    ~H"""
    <header
      data-mui-chat-header
      class={CN.cn(["flex min-h-14 shrink-0 items-center justify-between gap-3 border-b border-mui-border bg-mui-surface px-3.5 py-2.5", @class])}
      {@rest}
    >
      <div class="flex min-w-0 items-center gap-3">{render_slot(@inner_block)}</div>
      <div :if={@actions != []} class="flex shrink-0 items-center gap-1">
        {render_slot(@actions)}
      </div>
    </header>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def chat_header_title(assigns) do
    ~H"""
    <h2 class={CN.cn(["truncate text-sm font-semibold text-mui-foreground", @class])}>
      {render_slot(@inner_block)}
    </h2>
    """
  end

  attr :state, :string, default: "online", values: ~w(online away busy offline)
  attr :label, :string, required: true
  attr :class, :string, default: nil
  attr :rest, :global

  def chat_presence(assigns) do
    ~H"""
    <span
      data-mui-chat-presence={@state}
      class={CN.cn(["inline-flex min-w-0 items-center gap-1.5 text-xs text-mui-muted-foreground", @class])}
      {@rest}
    >
      <span class={["size-1.5 shrink-0 rounded-mui-full", presence_classes(@state)]} />
      <span class="truncate">{@label}</span>
    </span>
    """
  end

  attr :id, :string, required: true
  attr :message_id, :string, required: true
  attr :side, :string, default: "incoming", values: ~w(incoming outgoing system)
  attr :author_kind, :string, default: "person", values: ~w(person assistant system)
  attr :author, :string, default: nil
  attr :time, :string, default: nil
  attr :focused, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global
  slot :avatar
  slot :meta
  slot :inner_block, required: true

  def chat_message(assigns) do
    ~H"""
    <article
      id={@id}
      data-mui-chat-message
      data-message-id={@message_id}
      data-mui-side={@side}
      data-mui-author-kind={@author_kind}
      aria-current={@focused && "true"}
      tabindex="-1"
      class={
        CN.cn([
          "group/message flex scroll-my-12 items-end gap-2 outline-none",
          @side == "outgoing" && "flex-row-reverse",
          @side == "system" && "items-center justify-center",
          @class
        ])
      }
      {@rest}
    >
      <div :if={@avatar != [] && @side != "system"} class="mb-0.5 shrink-0">
        {render_slot(@avatar)}
      </div>
      <div class={[
        "flex min-w-0 max-w-[min(78%,34rem)] flex-col gap-1",
        @side == "outgoing" && "items-end",
        @side == "system" && "max-w-full items-center"
      ]}>
        <div
          :if={@author || @time || @meta != []}
          class={[
            "flex min-w-0 items-center gap-1.5 px-1 text-[11px] leading-4 text-mui-muted-foreground",
            @side == "outgoing" && "flex-row-reverse"
          ]}
        >
          <span :if={@author} class="truncate font-medium text-mui-foreground/80">{@author}</span>
          <time :if={@time}>{@time}</time>
          {render_slot(@meta)}
        </div>
        {render_slot(@inner_block)}
      </div>
    </article>
    """
  end

  attr :variant, :string, default: "incoming", values: ~w(incoming outgoing assistant system)
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def chat_bubble(assigns) do
    ~H"""
    <div
      data-mui-chat-bubble={@variant}
      class={CN.cn(["w-fit min-w-0 overflow-hidden text-left", bubble_classes(@variant), @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def chat_message_content(assigns) do
    ~H"""
    <div
      data-mui-chat-content
      class={
        CN.cn([
          "min-w-0 break-words text-sm leading-5",
          "[&_a]:font-medium [&_a]:text-mui-primary [&_a]:underline [&_a]:underline-offset-2",
          "[&_blockquote]:my-2 [&_blockquote]:border-l-2 [&_blockquote]:border-mui-border-strong [&_blockquote]:pl-3",
          "[&_code]:rounded-mui-sm [&_code]:bg-mui-surface-hover [&_code]:px-1 [&_code]:py-0.5 [&_code]:font-mono [&_code]:text-xs",
          "[&_li]:ml-4 [&_ol]:list-decimal [&_p:not(:first-child)]:mt-2 [&_pre]:my-2 [&_pre]:overflow-x-auto [&_ul]:list-disc",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :label, :string, required: true
  attr :class, :string, default: nil
  attr :rest, :global

  def chat_typing_indicator(assigns) do
    ~H"""
    <div
      data-mui-chat-typing
      role="status"
      aria-live="polite"
      class={CN.cn(["flex min-h-7 items-center gap-2 bg-mui-surface px-3.5 py-1 text-xs text-mui-muted-foreground", @class])}
      {@rest}
    >
      <span class="flex items-center gap-0.5" aria-hidden="true">
        <span :for={delay <- ~w(0ms 120ms 240ms)} class="mui-chat-typing-dot size-1 rounded-mui-full bg-mui-muted-foreground" style={"animation-delay: #{delay}"} />
      </span>
      <span>{@label}</span>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :for, :any, required: true
  attr :submit_on_enter, :boolean, default: true
  attr :clear_on_submit, :boolean, default: true
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(autocomplete name novalidate phx-change phx-submit phx-target)
  slot :inner_block, required: true

  def chat_composer(assigns) do
    ~H"""
    <.form
      id={@id}
      for={@for}
      data-mui-chat-composer
      data-submit-on-enter={to_string(@submit_on_enter)}
      data-clear-on-submit={to_string(@clear_on_submit)}
      phx-hook=".MUIChatComposer"
      class={
        CN.cn([
          "m-3 mt-2 flex shrink-0 items-end gap-1.5 rounded-mui-lg border border-mui-input-border bg-mui-input-background p-1.5 shadow-mui-input",
          "focus-within:border-mui-primary focus-within:ring-2 focus-within:ring-mui-ring/20",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </.form>

    <script :type={Phoenix.LiveView.ColocatedHook} name=".MUIChatComposer">
      export default {
        mounted() {
          this.submittedEditors = []

          this.onKeydown = (event) => {
            const editor = event.target.closest("textarea, [contenteditable='true']")
            const modified = event.shiftKey || event.altKey || event.ctrlKey || event.metaKey

            if (!editor || event.key !== "Enter" || modified || event.isComposing) return
            if (this.el.dataset.submitOnEnter !== "true") return

            event.preventDefault()
            this.el.requestSubmit()
          }

          this.onSubmit = () => {
            if (this.el.dataset.clearOnSubmit !== "true") return

            const editors = Array.from(this.el.querySelectorAll("textarea, input[type='text']"))
            this.submittedEditors = editors.map((editor) => ({
              id: editor.id,
              name: editor.name,
              value: editor.value
            }))

            clearTimeout(this.clearTimer)
            this.clearTimer = setTimeout(() => this.submittedEditors = [], 2_000)
            requestAnimationFrame(() => this.clearSubmittedValues())
          }

          this.onInput = (event) => {
            if (!event.isTrusted || this.submittedEditors.length === 0) return

            const submitted = this.submittedEditors.find((editor) =>
              editor.id ? editor.id === event.target.id : editor.name === event.target.name
            )

            if (submitted && event.target.value !== submitted.value) this.submittedEditors = []
          }

          this.el.addEventListener("keydown", this.onKeydown)
          this.el.addEventListener("submit", this.onSubmit)
          this.el.addEventListener("input", this.onInput)
        },
        updated() {
          this.clearSubmittedValues()
        },
        destroyed() {
          clearTimeout(this.clearTimer)
          this.el.removeEventListener("keydown", this.onKeydown)
          this.el.removeEventListener("submit", this.onSubmit)
          this.el.removeEventListener("input", this.onInput)
        },
        clearSubmittedValues() {
          if (this.submittedEditors.length === 0) return

          const editors = Array.from(this.el.querySelectorAll("textarea, input[type='text']"))

          this.submittedEditors.forEach((submitted) => {
            const editor = editors.find((candidate) =>
              submitted.id ? submitted.id === candidate.id : submitted.name === candidate.name
            )

            if (!editor || editor.value !== submitted.value) return
            editor.value = ""
            editor.dispatchEvent(new Event("input", {bubbles: true}))
          })
        }
      }
    </script>
    """
  end

  defp presence_classes("online"), do: "bg-mui-success"
  defp presence_classes("away"), do: "bg-mui-warning"
  defp presence_classes("busy"), do: "bg-mui-danger"
  defp presence_classes("offline"), do: "bg-mui-muted-foreground"

  defp bubble_classes("incoming"),
    do:
      "rounded-mui-lg rounded-bl-mui-xs border border-mui-border bg-mui-surface px-3 py-2 text-mui-foreground shadow-mui-xs"

  defp bubble_classes("outgoing"),
    do:
      "rounded-mui-lg rounded-br-mui-xs bg-mui-primary-subtle px-3 py-2 text-mui-primary-subtle-foreground"

  defp bubble_classes("assistant"),
    do:
      "rounded-mui-lg rounded-bl-mui-xs border border-mui-border bg-mui-accent-subtle px-3 py-2 text-mui-accent-subtle-foreground"

  defp bubble_classes("system"),
    do:
      "rounded-mui-full border border-mui-border bg-mui-surface px-3 py-1 text-xs text-mui-muted-foreground"
end
