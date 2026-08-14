defmodule MatriarchUI.DateInput do
  @moduledoc "Masked regional date input that submits an ISO 8601 value."
  use Phoenix.Component
  alias MatriarchUI.{CN, Config}

  attr :field, Phoenix.HTML.FormField
  attr :name, :any, default: nil
  attr :id, :any, default: nil
  attr :value, :any, default: nil
  attr :min, :any, default: nil
  attr :max, :any, default: nil
  attr :format, :string, default: nil
  attr :placeholder, :string, default: nil
  attr :invalid, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(autocomplete disabled readonly required)

  def date_input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(
      field: nil,
      invalid: used_input?(field) && field.errors != [],
      name: assigns.name || field.name,
      id: assigns.id || field.id,
      value: if(is_nil(assigns.value), do: field.value, else: assigns.value)
    )
    |> date_input()
  end

  def date_input(assigns) do
    assigns =
      assigns
      |> assign(:format, assigns.format || Config.date_format())
      |> assign(:iso_value, normalize_date(assigns.value))

    ~H"""
    <div id={"#{@id}-date-input"} data-mui data-mui-date-input class="contents">
      <input
        type="hidden"
        id={"#{@id}-value"}
        name={@name}
        value={@iso_value}
        disabled={@rest[:disabled]}
        data-mui-date-value
      />
      <input
        data-mui-control
        type="text"
        inputmode="numeric"
        name={nil}
        id={@id}
        phx-hook=".MUIDateInput"
        value={format_date(@iso_value, @format)}
        placeholder={@placeholder || @format}
        aria-invalid={to_string(@invalid)}
        data-mui-date-format={@format}
        data-mui-date-min={normalize_date(@min)}
        data-mui-date-max={normalize_date(@max)}
        data-mui-date-value-target={"#{@id}-value"}
        class={
          CN.cn([
            "mui-input h-8 w-full rounded-mui-md border border-transparent bg-mui-input-background px-3 text-sm text-mui-foreground",
            "placeholder:text-mui-input-placeholder focus-visible:border-mui-brand focus-visible:ring-2 focus-visible:ring-mui-slider-ring disabled:cursor-not-allowed disabled:opacity-50",
            @invalid && "border-mui-danger focus-visible:ring-mui-danger/30",
            @class
          ])
        }
        {@rest}
      />
    </div>
    """
  end

  defp normalize_date(%Date{} = date), do: Date.to_iso8601(date)
  defp normalize_date(nil), do: ""
  defp normalize_date(value), do: to_string(value)

  defp format_date("", _format), do: ""

  defp format_date(value, format) do
    with {:ok, date} <- Date.from_iso8601(value) do
      format
      |> String.replace("YYYY", date.year |> Integer.to_string() |> String.pad_leading(4, "0"))
      |> String.replace("MM", date.month |> Integer.to_string() |> String.pad_leading(2, "0"))
      |> String.replace("DD", date.day |> Integer.to_string() |> String.pad_leading(2, "0"))
    else
      _ -> value
    end
  end

  attr :rest, :global

  def hook(assigns) do
    ~H"""
    <script :type={Phoenix.LiveView.ColocatedHook} name=".MUIDateInput">
      function isoParts(value) {
        const match = /^(\d{4})-(\d{2})-(\d{2})$/.exec(value || "")
        return match ? { YYYY: match[1], MM: match[2], DD: match[3] } : null
      }

      function validDate(parts) {
        const year = Number(parts.YYYY)
        const month = Number(parts.MM)
        const day = Number(parts.DD)
        const date = new Date(year, month - 1, day)
        return date.getFullYear() === year && date.getMonth() === month - 1 && date.getDate() === day
      }

      export default {
        mounted() {
          const input = this.el
          const value = document.getElementById(input.dataset.muiDateValueTarget)
          const format = input.dataset.muiDateFormat
          const tokens = format.match(/YYYY|MM|DD/g) || ["YYYY", "MM", "DD"]
          const separators = format.split(/YYYY|MM|DD/g).filter(Boolean)
          const min = input.dataset.muiDateMin
          const max = input.dataset.muiDateMax
          const abort = new AbortController()
          const signal = abort.signal

          const display = (iso) => {
            const parts = isoParts(iso)
            if (!parts) return ""
            return format
              .replace("YYYY", parts.YYYY)
              .replace("MM", parts.MM)
              .replace("DD", parts.DD)
          }

          const mask = (raw) => {
            const digits = raw.replace(/\D/g, "").slice(0, 8)
            let offset = 0
            return tokens.reduce((result, token, index) => {
              const length = token.length
              const part = digits.slice(offset, offset + length)
              offset += part.length
              if (part === "") return result
              const separator = result === "" ? "" : separators[index - 1] || separators[0] || "-"
              return `${result}${separator}${part}`
            }, "")
          }

          const parse = (text) => {
            const digits = text.replace(/\D/g, "")
            if (digits.length !== 8) return ""
            let offset = 0
            const parts = Object.fromEntries(tokens.map((token) => {
              const part = digits.slice(offset, offset + token.length)
              offset += token.length
              return [token, part]
            }))
            if (!validDate(parts)) return ""
            const iso = `${parts.YYYY}-${parts.MM}-${parts.DD}`
            if ((min && iso < min) || (max && iso > max)) return ""
            return iso
          }

          const sync = (iso, notify = true) => {
            value.value = iso
            if (!notify) return
            value.dispatchEvent(new Event("input", { bubbles: true }))
            value.dispatchEvent(new Event("change", { bubbles: true }))
          }

          input.addEventListener("input", () => {
            input.value = mask(input.value)
            sync(parse(input.value))
          }, { signal })

          input.addEventListener("mui:date-value", (event) => {
            const iso = event.detail?.value || ""
            input.value = display(iso)
            sync(iso)
          }, { signal })

          input.value = display(value.value)
          this.muiAbort = abort
          this.muiRenderDate = () => { input.value = display(value.value) }
        },
        updated() {
          if (this.muiRenderDate) this.muiRenderDate()
        },
        destroyed() {
          if (this.muiAbort) this.muiAbort.abort()
        }
      }
    </script>
    """
  end
end
