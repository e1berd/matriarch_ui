defmodule MatriarchUI.Pagination do
  @moduledoc "Previous/next navigation with an editable, bounded current page."
  use Phoenix.Component
  alias MatriarchUI.{CN, I18n}
  import MatriarchUI.Icon

  attr :id, :string, required: true
  attr :page, :integer, required: true
  attr :total_pages, :integer, required: true
  attr :event, :string, default: "paginate"
  attr :target, :any, default: nil
  attr :locale, :string, default: "en"
  attr :class, :string, default: nil
  slot :page_size

  def pagination(assigns) do
    assigns =
      assigns
      |> assign(:total_pages, max(assigns.total_pages, 1))
      |> assign(:page, assigns.page |> max(1) |> min(max(assigns.total_pages, 1)))

    ~H"""
    <div
      id={@id}
      data-mui
      class={CN.cn(["flex w-full items-center justify-between gap-4", @class])}
    >
      <div
        :if={@page_size != []}
        class="flex items-center gap-2 text-sm text-mui-muted-foreground"
      >
        <span>{I18n.t(@locale, "pagination.results_per_page")}</span>
        {render_slot(@page_size)}
      </div>
      <nav
        aria-label={I18n.t(@locale, "pagination.aria_label")}
        class="flex items-center gap-1.5"
      >
          <button
            id={"#{@id}-previous"}
            type="button"
            phx-click={@event}
            phx-value-page={@page - 1}
            phx-target={@target}
            disabled={@page <= 1}
            aria-label={I18n.t(@locale, "pagination.previous_page")}
            class="flex size-8 items-center justify-center rounded-mui-md border border-mui-border bg-mui-surface text-mui-foreground transition-all hover:bg-mui-surface-hover active:scale-97 disabled:pointer-events-none disabled:opacity-40"
          >
            <.icon name="caret-left" />
          </button>

          <input
            id={"#{@id}-page"}
            name="page"
            type="number"
            inputmode="numeric"
            min="1"
            max={@total_pages}
            step="1"
            value={@page}
            phx-hook=".MUIPagination"
            phx-change={@event}
            phx-target={@target}
            phx-debounce="300"
            aria-label={I18n.t(@locale, "pagination.current_page")}
            class="mui-input mui-pagination-page h-8 w-12 rounded-mui-md border border-transparent bg-mui-input-background px-1 text-center text-sm text-mui-foreground focus-visible:border-mui-brand focus-visible:ring-2 focus-visible:ring-mui-slider-ring"
          />
          <span class="min-w-8 text-sm text-mui-muted-foreground">
            {I18n.t(@locale, "pagination.of")} {@total_pages}
          </span>

          <button
            id={"#{@id}-next"}
            type="button"
            phx-click={@event}
            phx-value-page={@page + 1}
            phx-target={@target}
            disabled={@page >= @total_pages}
            aria-label={I18n.t(@locale, "pagination.next_page")}
            class="flex size-8 items-center justify-center rounded-mui-md border border-mui-border bg-mui-surface text-mui-foreground transition-all hover:bg-mui-surface-hover active:scale-97 disabled:pointer-events-none disabled:opacity-40"
          >
            <.icon name="caret-right" />
          </button>
      </nav>
    </div>
    """
  end

  attr :rest, :global

  def hook(assigns) do
    ~H"""
    <script :type={Phoenix.LiveView.ColocatedHook} name=".MUIPagination">
      export default {
        mounted() {
          const input = this.el
          const min = Number(input.min)
          const max = Number(input.max)
          const abort = new AbortController()
          const signal = abort.signal
          const clamp = () => {
            if (input.value === "") return
            input.value = String(Math.min(max, Math.max(min, Number(input.value) || min)))
          }
          input.addEventListener("input", clamp, { signal })
          input.addEventListener("blur", () => {
            if (input.value === "") {
              input.value = String(min)
              input.dispatchEvent(new Event("input", { bubbles: true }))
            }
          }, { signal })
          this.muiAbort = abort
        },
        destroyed() {
          if (this.muiAbort) this.muiAbort.abort()
        }
      }
    </script>
    """
  end
end
