defmodule MatriarchUI.CommandPalette do
  @moduledoc """
  ⌘K-style search dialog. The trigger, dialog shell, arrow-key navigation,
  entrance animation and result rendering (with optional `<mark>`
  highlighting) are all built in — where results come from is entirely up to
  you. Wire it up the same way you would `.pagination` or `.table_filters`:
  bind `event`/`target`, receive the query on your own `phx-change` handler
  as `%{"search" => %{"query" => query}}`, look results up however you like
  (in-process text match, a database query, an HTTP call, anything), and
  assign them back as `results`.

      def handle_event("search", %{"search" => %{"query" => query}}, socket) do
        {:noreply, assign(socket, query: query, results: MyApp.Search.run(query))}
      end

  Each result is a map: `%{id: unique_string, url: string, title: text, description: text | nil}`,
  where `text` is either a plain string (rendered unhighlighted) or a list of
  `{:text, string} | {:mark, string}` segments (rendered with `<mark>` runs
  around the `:mark` parts) — see `MatriarchUI.Search.highlight/2` and
  `MatriarchUI.Search.snippet/3` for building those from plain in-process
  text matching.

  Render `command_palette_trigger/1` (the ⌘K button) and `command_palette/1`
  (the dialog) as a pair, anywhere in the same LiveView — most often once in
  a shared header/layout.
  """
  use Phoenix.Component
  alias MatriarchUI.{CN, I18n}
  import MatriarchUI.{Icon, Input, Modal}
  alias Phoenix.LiveView.JS

  attr :id, :string,
    required: true,
    doc: "must match the `id` given to the paired `command_palette/1`"

  attr :locale, :string, default: "en"
  attr :class, :string, default: nil

  def command_palette_trigger(assigns) do
    ~H"""
    <button
      type="button"
      id={"#{@id}-trigger"}
      phx-hook=".MUICommandPaletteShortcut"
      phx-click={MatriarchUI.Modal.show_modal("#{@id}-modal") |> JS.focus(to: "##{@id}-input")}
      class={
        CN.cn([
          "flex h-7 items-center gap-2 rounded-mui-md border border-mui-border bg-mui-surface px-2.5",
          "text-[13px] text-mui-muted-foreground hover:bg-mui-surface-hover hover:text-mui-foreground",
          @class
        ])
      }
      aria-label={I18n.t(@locale, "command_palette.trigger")}
    >
      <.icon name="magnifying-glass" class="size-3.5" />
      <span class="hidden sm:inline">{I18n.t(@locale, "command_palette.trigger")}</span>
      <kbd class="hidden rounded border border-mui-border bg-mui-surface-hover px-1 font-mono text-[10px] text-mui-subtle-foreground sm:inline">
        ⌘K
      </kbd>
    </button>

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
    doc: "must match the `id` given to the paired `command_palette_trigger/1`"

  attr :query, :string, default: ""
  attr :results, :list, default: [], doc: "list of `%{id:, url:, title:, description:}` maps"
  attr :event, :string, required: true, doc: "phx-change event name pushed as the reader types"

  attr :target, :any,
    default: nil,
    doc: "phx-target for `event`, e.g. `@myself` in a LiveComponent"

  attr :locale, :string, default: "en"
  attr :max_length, :integer, default: 80, doc: "maxlength of the search input"
  attr :class, :string, default: nil

  def command_palette(assigns) do
    assigns =
      assign(
        assigns,
        :form,
        to_form(%{"query" => assigns.query}, as: "search", id: "#{assigns.id}-form")
      )

    ~H"""
    <.modal id={"#{@id}-modal"} class={CN.cn(["mt-[8vh]! max-w-lg", @class])}>
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
            <.command_palette_idle :if={@query == ""} locale={@locale} />
            <.command_palette_not_found :if={@query != "" and @results == []} locale={@locale} />
            <ul
              :if={@results != []}
              id={"#{@id}-listbox"}
              role="listbox"
              class="flex max-h-80 flex-col gap-0.5 overflow-y-auto"
            >
              <li
                :for={result <- @results}
                id={"#{@id}-result-#{result.id}"}
                phx-mounted={
                  JS.transition(
                    {"transition-all duration-500 ease-mui-out", "opacity-0 -translate-y-2",
                     "opacity-100 translate-y-0"}
                  )
                }
              >
                <.link
                  navigate={result.url}
                  id={"#{@id}-option-#{result.id}"}
                  role="option"
                  aria-selected="false"
                  class={
                    CN.cn([
                      "block rounded-mui-md px-2.5 py-2 outline-none hover:bg-mui-surface-hover",
                      "aria-selected:bg-mui-surface-hover aria-selected:ring-2 aria-selected:ring-mui-brand/30"
                    ])
                  }
                >
                  <p class="text-sm font-medium text-mui-foreground">
                    <.segments value={result.title} />
                  </p>
                  <p :if={result[:description]} class="mt-0.5 text-xs text-mui-muted-foreground">
                    <.segments value={result.description} />
                  </p>
                </.link>
              </li>
            </ul>
          </div>
        </div>

        <div class="mt-3 flex items-center gap-3 border-t border-mui-border pt-2.5 text-[11px] text-mui-subtle-foreground">
          <span class="flex items-center gap-1">
            <.kbd>↑</.kbd><.kbd>↓</.kbd>{I18n.t(@locale, "command_palette.kbd_navigate")}
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
    </.modal>
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

  attr :value, :any,
    required: true,
    doc: "a plain string, or a list of `{:text, _} | {:mark, _}` segments"

  defp segments(%{value: value} = assigns) when is_binary(value) do
    ~H"{@value}"
  end

  defp segments(assigns) do
    ~H"""
    <%= for {kind, text} <- @value do %>
      <mark :if={kind == :mark} class="rounded-sm bg-mui-accent-subtle px-0.5 text-mui-accent-subtle-foreground">{text}</mark>
      <span :if={kind == :text}>{text}</span>
    <% end %>
    """
  end

  slot :inner_block, required: true

  defp kbd(assigns) do
    ~H"""
    <kbd class="rounded border border-mui-border bg-mui-surface-hover px-1 py-0.5 font-mono text-[10px]">
      {render_slot(@inner_block)}
    </kbd>
    """
  end
end
