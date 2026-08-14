defmodule MatriarchUI.DatePicker do
  @moduledoc "Calendar trigger for a separate `MatriarchUI.DateInput` control."
  use Phoenix.Component
  alias MatriarchUI.{CN, Floating}
  alias MatriarchUI.I18n
  import MatriarchUI.Icon

  attr :id, :string, required: true
  attr :for, :string, required: true
  attr :min, :any, default: nil
  attr :max, :any, default: nil
  attr :locale, :string, default: "en"
  attr :week_start, :integer, default: 1, values: 0..6
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled)

  def date_picker(assigns) do
    assigns =
      assigns
      |> assign(:min_value, normalize_date(assigns.min))
      |> assign(:max_value, normalize_date(assigns.max))

    ~H"""
    <div
      id={"#{@id}-root"}
      data-mui
      data-mui-date-picker
      data-mui-date-target={@for}
      data-mui-locale={@locale}
      data-mui-week-start={@week_start}
      data-mui-min={@min_value}
      data-mui-max={@max_value}
      class="inline-flex"
    >
      <button
        type="button"
        id={@id}
        phx-hook="MatriarchUI.Floating.MUIFloating"
        aria-label={I18n.t(@locale, "date_picker.open_calendar")}
        aria-controls={"#{@id}-panel"}
        aria-haspopup="dialog"
        aria-expanded="false"
        data-mui-control
        data-mui-trigger="click"
        data-mui-persistent="true"
        data-mui-placement="bottom-end"
        data-mui-axis="vertical"
        disabled={@rest[:disabled]}
        class={
          CN.cn([
            "flex size-8 items-center justify-center rounded-mui-md border border-mui-border bg-mui-surface text-mui-muted-foreground",
            "hover:bg-mui-surface-hover hover:text-mui-foreground disabled:pointer-events-none disabled:opacity-50",
            @class
          ])
        }
      >
        <.icon name="calendar-blank" />
      </button>
      <div
        id={"#{@id}-panel"}
        phx-hook=".MUIDatePicker"
        phx-update="ignore"
        role="dialog"
        aria-label={I18n.t(@locale, "date_picker.choose_date")}
        data-mui-state="closed"
        class={CN.cn([Floating.panel_class(), "w-72 rounded-mui-lg border border-mui-border bg-mui-surface p-3 text-sm shadow-mui-lg"])}
      >
        <div class="mb-2 flex items-center justify-between">
          <button
            type="button"
            data-mui-date-prev
            aria-label={I18n.t(@locale, "date_picker.previous_month")}
            class="flex size-7 items-center justify-center rounded-mui-sm text-mui-muted-foreground hover:bg-mui-surface-hover hover:text-mui-foreground"
          >
            <.icon name="caret-left" />
          </button>
          <span data-mui-date-heading aria-live="polite" class="font-medium text-mui-foreground" />
          <button
            type="button"
            data-mui-date-next
            aria-label={I18n.t(@locale, "date_picker.next_month")}
            class="flex size-7 items-center justify-center rounded-mui-sm text-mui-muted-foreground hover:bg-mui-surface-hover hover:text-mui-foreground"
          >
            <.icon name="caret-right" />
          </button>
        </div>
        <div data-mui-date-weekdays class="grid grid-cols-7 text-center text-xs text-mui-muted-foreground" />
        <div data-mui-date-grid role="grid" class="mt-1 grid grid-cols-7 gap-0.5" />
        <div class="mt-2 flex items-center justify-between border-t border-mui-border pt-2">
          <button type="button" data-mui-date-clear class="text-xs text-mui-muted-foreground hover:text-mui-foreground">
            {I18n.t(@locale, "date_picker.clear")}
          </button>
          <button type="button" data-mui-date-today class="text-xs font-medium text-mui-primary hover:underline">
            {I18n.t(@locale, "date_picker.today")}
          </button>
        </div>
      </div>
    </div>
    """
  end

  defp normalize_date(%Date{} = date), do: Date.to_iso8601(date)
  defp normalize_date(nil), do: nil
  defp normalize_date(value), do: to_string(value)

  attr :rest, :global

  def hook(assigns) do
    ~H"""
    <script :type={Phoenix.LiveView.ColocatedHook} name=".MUIDatePicker">
      function parseDate(value) {
        const match = /^(\d{4})-(\d{2})-(\d{2})$/.exec(value || "")
        if (!match) return null
        return new Date(Number(match[1]), Number(match[2]) - 1, Number(match[3]))
      }

      function isoDate(date) {
        const year = String(date.getFullYear()).padStart(4, "0")
        const month = String(date.getMonth() + 1).padStart(2, "0")
        const day = String(date.getDate()).padStart(2, "0")
        return `${year}-${month}-${day}`
      }

      function sameDay(left, right) {
        return left && right && isoDate(left) === isoDate(right)
      }

      export default {
        mounted() {
          const panel = this.el
          const root = panel.closest("[data-mui-date-picker]")
          const input = document.getElementById(root.dataset.muiDateTarget)
          if (!input) return
          const value = document.getElementById(input.dataset.muiDateValueTarget) || input

          const heading = panel.querySelector("[data-mui-date-heading]")
          const weekdays = panel.querySelector("[data-mui-date-weekdays]")
          const grid = panel.querySelector("[data-mui-date-grid]")
          const locale = root.dataset.muiLocale || document.documentElement.lang || navigator.language
          const weekStart = Number(root.dataset.muiWeekStart || "1")
          const min = parseDate(root.dataset.muiMin || input.dataset.muiDateMin || input.min)
          const max = parseDate(root.dataset.muiMax || input.dataset.muiDateMax || input.max)
          const today = new Date()
          let selected = parseDate(value.value)
          let cursor = new Date((selected || today).getFullYear(), (selected || today).getMonth(), 1)
          let active = selected || today
          const abort = new AbortController()
          const signal = abort.signal
          const dateFormatter = new Intl.DateTimeFormat(locale, { dateStyle: "medium" })
          const monthFormatter = new Intl.DateTimeFormat(locale, { month: "long", year: "numeric" })
          const weekdayFormatter = new Intl.DateTimeFormat(locale, { weekday: "short" })

          const unavailable = (date) => (min && date < min) || (max && date > max)

          const weekdayDates = () => {
            const sunday = new Date(2024, 0, 7)
            return Array.from({ length: 7 }, (_, index) => {
              const date = new Date(sunday)
              date.setDate(sunday.getDate() + ((weekStart + index) % 7))
              return date
            })
          }

          const focusActive = () => {
            requestAnimationFrame(() => {
              grid.querySelector(`[data-mui-date="${isoDate(active)}"]`)?.focus()
            })
          }

          const render = () => {
            heading.textContent = monthFormatter.format(cursor)
            weekdays.replaceChildren(
              ...weekdayDates().map((date) => {
                const label = document.createElement("span")
                label.textContent = weekdayFormatter.format(date)
                label.setAttribute("aria-hidden", "true")
                label.className = "py-1"
                return label
              })
            )

            const first = new Date(cursor.getFullYear(), cursor.getMonth(), 1)
            const offset = (first.getDay() - weekStart + 7) % 7
            const start = new Date(first)
            start.setDate(first.getDate() - offset)

            const days = Array.from({ length: 42 }, (_, index) => {
              const date = new Date(start)
              date.setDate(start.getDate() + index)
              const button = document.createElement("button")
              const inMonth = date.getMonth() === cursor.getMonth()
              button.type = "button"
              button.role = "gridcell"
              button.textContent = String(date.getDate())
              button.dataset.muiDate = isoDate(date)
              button.dataset.muiOutside = String(!inMonth)
              button.dataset.muiToday = String(sameDay(date, today))
              button.setAttribute("aria-label", dateFormatter.format(date))
              button.setAttribute("aria-selected", String(sameDay(date, selected)))
              button.tabIndex = sameDay(date, active) ? 0 : -1
              button.disabled = unavailable(date)
              button.className = "flex aspect-square items-center justify-center rounded-mui-sm text-xs text-mui-foreground hover:bg-mui-surface-hover focus:outline-none focus-visible:ring-2 focus-visible:ring-mui-ring/30 disabled:pointer-events-none disabled:opacity-30 data-[mui-outside=true]:text-mui-muted-foreground data-[mui-outside=true]:opacity-50 data-[mui-today=true]:border data-[mui-today=true]:border-mui-brand aria-selected:bg-mui-primary aria-selected:text-mui-primary-foreground"
              return button
            })

            grid.replaceChildren(...days)
          }

          const select = (date) => {
            if (!date || unavailable(date)) return
            selected = date
            active = date
            cursor = new Date(date.getFullYear(), date.getMonth(), 1)
            input.dispatchEvent(new CustomEvent("mui:date-value", {
              detail: { value: isoDate(date) }
            }))
            render()
          }

          const moveActive = (days) => {
            active = new Date(active)
            active.setDate(active.getDate() + days)
            cursor = new Date(active.getFullYear(), active.getMonth(), 1)
            render()
            focusActive()
          }

          panel.addEventListener("click", (event) => {
            const day = event.target.closest("[data-mui-date]")
            if (day) select(parseDate(day.dataset.muiDate))
          }, { signal })

          panel.addEventListener("keydown", (event) => {
            const moves = { ArrowLeft: -1, ArrowRight: 1, ArrowUp: -7, ArrowDown: 7 }
            if (moves[event.key]) {
              event.preventDefault()
              moveActive(moves[event.key])
            } else if (event.key === "Enter" || event.key === " ") {
              const day = event.target.closest("[data-mui-date]")
              if (day) {
                event.preventDefault()
                select(parseDate(day.dataset.muiDate))
              }
            }
          }, { signal })

          panel.querySelector("[data-mui-date-prev]").addEventListener("click", () => {
            cursor = new Date(cursor.getFullYear(), cursor.getMonth() - 1, 1)
            active = new Date(cursor)
            render()
          }, { signal })

          panel.querySelector("[data-mui-date-next]").addEventListener("click", () => {
            cursor = new Date(cursor.getFullYear(), cursor.getMonth() + 1, 1)
            active = new Date(cursor)
            render()
          }, { signal })

          panel.querySelector("[data-mui-date-today]").addEventListener("click", () => select(today), { signal })
          panel.querySelector("[data-mui-date-clear]").addEventListener("click", () => {
            selected = null
            input.dispatchEvent(new CustomEvent("mui:date-value", { detail: { value: "" } }))
            render()
          }, { signal })

          value.addEventListener("change", () => {
            selected = parseDate(value.value)
            if (selected) {
              active = selected
              cursor = new Date(selected.getFullYear(), selected.getMonth(), 1)
            }
            render()
          }, { signal })

          render()
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
