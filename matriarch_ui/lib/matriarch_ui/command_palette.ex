defmodule MatriarchUI.CommandPalette do
  @moduledoc """
  ⌘K-style search dialog. The dialog shell, arrow-key navigation, entrance
  animation and result highlighting are all built in — where results come
  from, and what your trigger looks like, are entirely up to you. Unlike
  `.popover`/`.dropdown_menu`, the trigger doesn't need to anchor anything —
  the dialog opens centered near the top of the viewport regardless of where
  the trigger sits on the page — so it lives in `command_palette/1`'s own
  `:trigger` slot rather than a separate component.

      <.command_palette id="search">
        <:trigger><.button>Search</.button></:trigger>

        <.command_palette_search id="search" query={@query} event="search" mode="search" locale={@locale}>
          <:command
            :for={result <- @results}
            id={result.id}
            value={result.url}
            icon={result.icon}
            title={result.title}
            subtitle={result.description}
          />
        </.command_palette_search>
      </.command_palette>

  Wire the query the same way you would `.pagination` or `.table_filters`:
  bind `event`/`target` on `command_palette_search/1`, receive the query on
  your own `phx-change` handler as `%{"search" => %{"query" => query}}`, look
  results up however you like (in-process text match, a database query, an
  HTTP call, anything) and assign them back as a plain list of maps.
  `title`/`subtitle` are plain strings — no highlighting math required, they
  get `<mark>`-highlighted against the current query automatically.

      def handle_event("search", %{"search" => %{"query" => query}}, socket) do
        {:noreply, assign(socket, query: query, results: MyApp.Search.run(query))}
      end

  `mode` defaults to `"raw"` — always render `:command`, even before the
  reader types anything, for a fixed list of tools/actions. Pass
  `mode="search"` (as above) to wait for a query first, showing an idle hint
  until then, for searching over content instead.

  `command_palette/1` (the trigger + the native `<dialog>` shell) and
  `command_palette_search/1` (the input + results, which re-renders on every
  keystroke) are separate components on purpose: if the page they're both on
  re-renders often for an unrelated reason, wrap `command_palette_search/1`
  in your own `Phoenix.LiveComponent` so only it re-renders, not the dialog
  around it — a native `<dialog>`'s open/closed state is client-only, and a
  LiveView patch reconstructing it from scratch (even for a sibling's sake)
  resets that state and can steal focus back from the input.
  `matriarch_ui_docs`'s own header search does exactly this.
  """
  use Phoenix.Component
  alias MatriarchUI.{CN, I18n, Search}
  import MatriarchUI.{Icon, Input, Kbd, Modal}
  alias Phoenix.LiveView.JS

  attr :id, :string,
    required: true,
    doc: "must match the `id` given to the paired `command_palette_search/1`"

  attr :class, :string, default: nil
  slot :trigger, required: true, doc: "your own trigger content, e.g. a `.button`"
  slot :inner_block, required: true, doc: "usually a `command_palette_search/1`"

  def command_palette(assigns) do
    ~H"""
    <div
      id={"#{@id}-trigger"}
      phx-hook=".MUICommandPaletteShortcut"
      phx-click={MatriarchUI.Modal.show_modal("#{@id}-modal") |> JS.focus(to: "##{@id}-input")}
      class="inline-flex"
    >
      {render_slot(@trigger)}
    </div>

    <.modal id={"#{@id}-modal"} class={CN.cn(["mt-[8vh]! max-w-lg", @class])}>
      {render_slot(@inner_block)}
    </.modal>

    <script :type={Phoenix.LiveView.ColocatedHook} name=".MUICommandPaletteShortcut">
      export default {
        mounted() {
          this.onKeydown = (event) => {
            const key = event.key.toLowerCase()
            if ((event.metaKey || event.ctrlKey) && key === "k") {
              event.preventDefault()
              this.el.click()
            }
          }
          window.addEventListener("keydown", this.onKeydown)
        },
        destroyed() {
          window.removeEventListener("keydown", this.onKeydown)
        }
      }
    </script>
    """
  end

  attr :id, :string,
    required: true,
    doc: "must match the `id` given to the paired `command_palette/1`"

  attr :query, :string, default: ""
  attr :event, :string, required: true, doc: "phx-change event name pushed as the reader types"

  attr :target, :any,
    default: nil,
    doc: "phx-target for `event`, e.g. `@myself` in a LiveComponent"

  attr :locale, :string, default: "en"
  attr :max_length, :integer, default: 80, doc: "maxlength of the search input"

  attr :mode, :string,
    default: "raw",
    values: ~w(search raw),
    doc:
      "\"raw\" (the default) always renders :command, even with an empty query — for a fixed " <>
        "list of tools/actions. \"search\" waits for a query before rendering anything, " <>
        "showing an idle hint until then — for searching over content."

  slot :command, doc: "one per result" do
    attr :id, :string, required: true
    attr :value, :string, required: true, doc: "navigate destination"
    attr :icon, :string, doc: "phosphor icon name shown to the left, e.g. \"file\""
    attr :title, :string, required: true, doc: "highlighted against the current query"
    attr :subtitle, :string, doc: "highlighted against the current query"
  end

  def command_palette_search(assigns) do
    assigns =
      assign(
        assigns,
        :form,
        to_form(%{"query" => assigns.query}, as: "search", id: "#{assigns.id}-form")
      )

    ~H"""
    <div id={"#{@id}-panel"} phx-hook=".MUICommandPaletteNav">
      <.form for={@form} phx-change={@event} phx-target={@target}>
        <.input
          field={@form[:query]}
          id={"#{@id}-input"}
          autocomplete="off"
          placeholder={I18n.t(@locale, "command_palette.placeholder")}
          maxlength={@max_length}
          phx-debounce="150"
          role="combobox"
          aria-expanded="true"
          aria-autocomplete="list"
          aria-controls={"#{@id}-listbox"}
        >
          <:leading><.icon name="magnifying-glass" class="size-4" /></:leading>
        </.input>
      </.form>

      <div class="mt-3 grid grid-rows-[1fr] transition-[grid-template-rows] duration-300 ease-mui-out">
        <div class="overflow-hidden">
          <.command_palette_idle :if={@query == "" and @mode == "search"} locale={@locale} />
          <.command_palette_not_found
            :if={(@query != "" or @mode == "raw") and @command == []}
            locale={@locale}
          />
          <ul
            :if={@command != [] and (@query != "" or @mode == "raw")}
            id={"#{@id}-listbox"}
            role="listbox"
            class="flex max-h-80 flex-col gap-0.5 overflow-y-auto"
          >
            <li
              :for={command <- @command}
              id={"#{@id}-result-#{command.id}"}
              phx-mounted={
                JS.transition(
                  {"transition-all duration-500 ease-mui-out", "opacity-0 -translate-y-2",
                   "opacity-100 translate-y-0"}
                )
              }
            >
              <.link
                navigate={command.value}
                id={"#{@id}-option-#{command.id}"}
                role="option"
                aria-selected="false"
                class={
                  CN.cn([
                    "flex items-start gap-2.5 rounded-mui-md px-2.5 py-2 outline-none hover:bg-mui-surface-hover",
                    "aria-selected:bg-mui-surface-hover aria-selected:ring-2 aria-selected:ring-mui-brand/30"
                  ])
                }
              >
                <.icon
                  :if={command[:icon]}
                  name={command.icon}
                  class="mt-0.5 size-4 shrink-0 text-mui-subtle-foreground"
                />
                <div class="min-w-0 flex-1">
                  <p class="text-sm font-medium text-mui-foreground">
                    <.segments value={Search.highlight(command.title, @query)} />
                  </p>
                  <p
                    :if={command[:subtitle]}
                    class="mt-0.5 text-xs text-mui-muted-foreground"
                  >
                    <.segments value={Search.highlight(command.subtitle, @query)} />
                  </p>
                </div>
              </.link>
            </li>
          </ul>
        </div>
      </div>

      <div class="mt-3 flex items-center gap-3 border-t border-mui-border pt-2.5 text-[11px] text-mui-subtle-foreground">
        <span class="flex items-center gap-1">
          <.kbd_group><.kbd>↑</.kbd><.kbd>↓</.kbd></.kbd_group>{I18n.t(
            @locale,
            "command_palette.kbd_navigate"
          )}
        </span>
        <span class="flex items-center gap-1">
          <.kbd>↵</.kbd>{I18n.t(@locale, "command_palette.kbd_select")}
        </span>
        <span class="flex items-center gap-1">
          <.kbd>Esc</.kbd>{I18n.t(@locale, "command_palette.kbd_close")}
        </span>
      </div>
    </div>

    <script :type={Phoenix.LiveView.ColocatedHook} name=".MUICommandPaletteNav">
      export default {
        mounted() {
          this.activeIndex = -1
          this.onKeydown = (event) => {
            const options = Array.from(this.el.querySelectorAll('[role="option"]'))

            if (event.key === "ArrowDown" && options.length > 0) {
              event.preventDefault()
              this.activeIndex = Math.min(this.activeIndex + 1, options.length - 1)
              this.applyActive(options)
            } else if (event.key === "ArrowUp" && options.length > 0) {
              event.preventDefault()
              this.activeIndex = Math.max(this.activeIndex - 1, 0)
              this.applyActive(options)
            } else if (event.key === "Enter") {
              event.preventDefault()
              if (options.length > 0) {
                options[this.activeIndex === -1 ? 0 : this.activeIndex]?.click()
              }
            }
          }
          this.el.addEventListener("keydown", this.onKeydown)
        },
        updated() {
          this.activeIndex = -1
        },
        applyActive(options) {
          const input = this.el.querySelector('[role="combobox"]')
          options.forEach((option, index) => {
            const active = index === this.activeIndex
            option.setAttribute("aria-selected", active ? "true" : "false")
            if (active) {
              option.scrollIntoView({block: "nearest"})
              input?.setAttribute("aria-activedescendant", option.id)
            }
          })
          if (this.activeIndex === -1) input?.removeAttribute("aria-activedescendant")
        },
        destroyed() {
          this.el.removeEventListener("keydown", this.onKeydown)
        }
      }
    </script>
    """
  end

  attr :locale, :string, required: true

  defp command_palette_idle(assigns) do
    ~H"""
    <div class="flex flex-col items-center gap-2 py-8 text-center">
      <.icon name="magnifying-glass" class="size-7 text-mui-subtle-foreground" />
      <p class="text-sm text-mui-muted-foreground">{I18n.t(@locale, "command_palette.hint")}</p>
    </div>
    """
  end

  attr :locale, :string, required: true

  defp command_palette_not_found(assigns) do
    ~H"""
    <div class="flex flex-col items-center gap-2 py-8 text-center">
      <.icon name="warning-circle" class="size-7 text-mui-subtle-foreground" />
      <p class="text-sm font-medium text-mui-foreground">
        {I18n.t(@locale, "command_palette.no_results")}
      </p>
      <p class="text-xs text-mui-muted-foreground">
        {I18n.t(@locale, "command_palette.no_results_hint")}
      </p>
    </div>
    """
  end

  attr :value, :list, required: true, doc: "a list of `{:text, _} | {:mark, _}` segments"

  defp segments(assigns) do
    ~H"""
    <%= for {kind, text} <- @value do %>
      <mark :if={kind == :mark} class="rounded-sm bg-mui-accent-subtle px-0.5 text-mui-accent-subtle-foreground">{text}</mark>
      <span :if={kind == :text}>{text}</span>
    <% end %>
    """
  end
end
