defmodule MatriarchUI.NumberInput do
  @moduledoc "Formatted numeric input with bounded stepping and pointer scrubbing."
  use Phoenix.Component
  alias MatriarchUI.CN
  import MatriarchUI.Icon

  attr :field, Phoenix.HTML.FormField
  attr :name, :any, default: nil
  attr :id, :any, default: nil
  attr :value, :any, default: nil
  attr :min, :any, default: nil
  attr :max, :any, default: nil
  attr :step, :any, default: 1
  attr :mask, :string, default: nil
  attr :decimal_separator, :string, default: "."
  attr :prefix, :string, default: nil
  attr :suffix, :string, default: nil
  attr :invalid, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(autocomplete disabled readonly required placeholder)

  def number_input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(
      field: nil,
      invalid: used_input?(field) && field.errors != [],
      name: assigns.name || field.name,
      id: assigns.id || field.id,
      value: if(is_nil(assigns.value), do: field.value, else: assigns.value)
    )
    |> number_input()
  end

  def number_input(assigns) do
    ~H"""
    <div
      id={"#{@id}-number-input"}
      data-mui
      data-mui-number-input
      data-mui-min={@min}
      data-mui-max={@max}
      data-mui-step={@step}
      data-mui-mask={@mask}
      data-mui-decimal-separator={@decimal_separator}
      data-mui-readonly={to_string(@rest[:readonly] || false)}
      data-mui-disabled={to_string(@rest[:disabled] || false)}
      class="w-full"
    >
      <input
        type="hidden"
        id={"#{@id}-value"}
        name={@name}
        value={normalize_value(@value)}
        disabled={@rest[:disabled]}
        data-mui-number-value
      />
      <div
        data-mui-control
        class={
          CN.cn([
            "mui-input flex h-8 w-full items-stretch rounded-mui-md border border-transparent bg-mui-input-background text-mui-foreground",
            "focus-within:border-mui-brand focus-within:ring-2 focus-within:ring-mui-slider-ring",
            (@rest[:disabled] || @rest[:readonly]) && "opacity-50",
            @invalid && "border-mui-danger focus-within:ring-mui-danger/30",
            @class
          ])
        }
      >
        <span
          :if={@prefix}
          class="flex shrink-0 items-center pl-3 text-sm text-mui-muted-foreground"
        >
          {@prefix}
        </span>
        <input
          type="text"
          inputmode="decimal"
          id={@id}
          phx-hook=".MUINumberInput"
          value={normalize_value(@value)}
          aria-invalid={to_string(@invalid)}
          data-mui-number-control
          data-mui-number-value-target={"#{@id}-value"}
          class="min-w-0 flex-1 cursor-ew-resize bg-transparent px-3 text-sm text-mui-foreground outline-none placeholder:text-mui-input-placeholder disabled:cursor-not-allowed"
          {@rest}
        />
        <span
          :if={@suffix}
          class="flex shrink-0 items-center pr-2 text-sm text-mui-muted-foreground"
        >
          {@suffix}
        </span>
        <div class="flex w-6 shrink-0 flex-col border-l border-mui-border">
          <button
            type="button"
            tabindex="-1"
            aria-label="Increase value"
            data-mui-number-step="1"
            disabled={@rest[:disabled] || @rest[:readonly]}
            class="flex min-h-0 flex-1 items-center justify-center rounded-tr-mui-md text-mui-muted-foreground hover:bg-mui-surface-hover hover:text-mui-foreground disabled:pointer-events-none"
          >
            <.icon name="caret-down" class="size-3 rotate-180" />
          </button>
          <button
            type="button"
            tabindex="-1"
            aria-label="Decrease value"
            data-mui-number-step="-1"
            disabled={@rest[:disabled] || @rest[:readonly]}
            class="flex min-h-0 flex-1 items-center justify-center rounded-br-mui-md border-t border-mui-border text-mui-muted-foreground hover:bg-mui-surface-hover hover:text-mui-foreground disabled:pointer-events-none"
          >
            <.icon name="caret-down" class="size-3" />
          </button>
        </div>
      </div>
    </div>
    """
  end

  defp normalize_value(nil), do: ""
  defp normalize_value(value), do: to_string(value)

  attr :rest, :global

  def hook(assigns) do
    ~H"""
    <script :type={Phoenix.LiveView.ColocatedHook} name=".MUINumberInput">
      export default {
        mounted() {
          const input = this.el
          const root = input.closest("[data-mui-number-input]")
          const value = document.getElementById(input.dataset.muiNumberValueTarget)
          const min = root.dataset.muiMin === undefined ? null : Number(root.dataset.muiMin)
          const max = root.dataset.muiMax === undefined ? null : Number(root.dataset.muiMax)
          const stepText = root.dataset.muiStep || "1"
          const step = Math.abs(Number(stepText)) || 1
          const precision = (stepText.split(".")[1] || "").length
          const mask = root.dataset.muiMask || ""
          const decimalSeparator = root.dataset.muiDecimalSeparator || "."
          const readonly = root.dataset.muiReadonly === "true"
          const disabled = root.dataset.muiDisabled === "true"
          const abort = new AbortController()
          const signal = abort.signal
          let holdDelay
          let holdInterval
          let scrub = null
          let scrubbed = false

          const round = (number) => Number(number.toFixed(Math.max(precision, 8)))
          const clamp = (number) => round(Math.min(max ?? Infinity, Math.max(min ?? -Infinity, number)))

          const rawNumber = (text) => {
            const normalized = text.replace(decimalSeparator, ".").replace(/[^\d.\-]/g, "")
            const negative = normalized.startsWith("-") ? "-" : ""
            const unsigned = normalized.replace(/-/g, "")
            const [integer = "", ...fractions] = unsigned.split(".")
            const fraction = fractions.join("")
            return `${negative}${integer}${fractions.length > 0 ? `.${fraction}` : ""}`
          }

          const applyMask = (integer) => {
            if (!mask || integer === "") return integer
            let digit = integer.length - 1
            let formatted = ""
            for (let index = mask.length - 1; index >= 0; index -= 1) {
              if (mask[index] === "#") {
                if (digit >= 0) formatted = integer[digit--] + formatted
              } else if (digit >= 0 && formatted !== "") {
                formatted = mask[index] + formatted
              }
            }
            return integer.slice(0, digit + 1) + formatted
          }

          const format = (raw) => {
            if (raw === "" || raw === "-" || raw === "." || raw === "-.") return raw
            const negative = raw.startsWith("-") ? "-" : ""
            const unsigned = raw.replace("-", "")
            const [integer, fraction] = unsigned.split(".")
            const decimal = fraction === undefined ? "" : `${decimalSeparator}${fraction}`
            return `${negative}${applyMask(integer)}${decimal}`
          }

          const notify = () => {
            value.dispatchEvent(new Event("input", { bubbles: true }))
            value.dispatchEvent(new Event("change", { bubbles: true }))
          }

          const commit = (raw, shouldClamp = false) => {
            const parsed = Number(raw)
            if (raw === "" || raw === "-" || !Number.isFinite(parsed)) {
              value.value = ""
              input.value = format(raw)
              notify()
              return
            }
            const number = shouldClamp || (max !== null && parsed > max) ? clamp(parsed) : parsed
            const normalized = precision > 0 ? String(round(number)) : String(Math.trunc(number))
            value.value = normalized
            input.value = format(normalized)
            notify()
          }

          const adjust = (direction) => {
            if (readonly || disabled) return
            const current = Number(value.value)
            const base = Number.isFinite(current) ? current : min ?? 0
            commit(String(clamp(base + step * direction)), true)
          }

          const stopHold = () => {
            clearTimeout(holdDelay)
            clearInterval(holdInterval)
          }

          root.querySelectorAll("[data-mui-number-step]").forEach((button) => {
            const direction = Number(button.dataset.muiNumberStep)
            button.addEventListener("pointerdown", (event) => {
              event.preventDefault()
              adjust(direction)
              holdDelay = setTimeout(() => {
                holdInterval = setInterval(() => adjust(direction), 65)
              }, 350)
            }, { signal })
            button.addEventListener("click", (event) => {
              if (event.detail === 0) adjust(direction)
            }, { signal })
          })

          window.addEventListener("pointerup", stopHold, { signal })
          window.addEventListener("pointercancel", stopHold, { signal })

          input.addEventListener("keydown", (event) => {
            if (["e", "E"].includes(event.key)) event.preventDefault()
            if (event.key === "ArrowUp" || event.key === "ArrowDown") {
              event.preventDefault()
              adjust(event.key === "ArrowUp" ? 1 : -1)
            }
          }, { signal })

          input.addEventListener("input", () => {
            const raw = rawNumber(input.value)
            commit(raw)
            input.setSelectionRange(input.value.length, input.value.length)
          }, { signal })

          input.addEventListener("blur", () => {
            if (value.value !== "") commit(value.value, true)
          }, { signal })

          input.addEventListener("pointerdown", (event) => {
            if (readonly || disabled || event.button !== 0) return
            scrub = {
              id: event.pointerId,
              x: event.clientX,
              value: Number(value.value) || min || 0,
              steps: 0
            }
            scrubbed = false
            input.setPointerCapture(event.pointerId)
          }, { signal })

          input.addEventListener("pointermove", (event) => {
            if (!scrub || scrub.id !== event.pointerId) return
            const steps = Math.trunc((event.clientX - scrub.x) / 8)
            if (steps === scrub.steps) return
            scrub.steps = steps
            scrubbed = true
            commit(String(clamp(scrub.value + steps * step)), true)
          }, { signal })

          input.addEventListener("pointerup", () => { scrub = null }, { signal })
          input.addEventListener("pointercancel", () => { scrub = null }, { signal })
          input.addEventListener("click", (event) => {
            if (scrubbed) event.preventDefault()
            scrubbed = false
          }, { signal })

          input.value = format(value.value)
          this.muiAbort = abort
          this.muiStopHold = stopHold
          this.muiRenderNumber = () => { input.value = format(value.value) }
        },
        updated() {
          if (this.muiRenderNumber) this.muiRenderNumber()
        },
        destroyed() {
          if (this.muiAbort) this.muiAbort.abort()
          if (this.muiStopHold) this.muiStopHold()
        }
      }
    </script>
    """
  end
end
