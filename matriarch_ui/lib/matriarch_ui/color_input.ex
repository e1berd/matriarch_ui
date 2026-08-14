defmodule MatriarchUI.ColorInput do
  @moduledoc "Color input combining a native picker, visible swatch, and editable CSS color value."
  use Phoenix.Component
  alias MatriarchUI.CN

  attr :field, Phoenix.HTML.FormField
  attr :name, :any, default: nil
  attr :id, :string, default: nil
  attr :value, :any, default: nil
  attr :invalid, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(autocomplete disabled readonly required placeholder)

  def color_input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(
      field: nil,
      invalid: used_input?(field) && field.errors != [],
      name: assigns.name || field.name,
      id: assigns.id || field.id,
      value: if(is_nil(assigns.value), do: field.value, else: assigns.value)
    )
    |> color_input()
  end

  def color_input(assigns) do
    assigns = assign(assigns, :color_value, normalize_color(assigns.value))

    ~H"""
    <div
      id={"#{@id}-color-input"}
      data-mui
      class={CN.cn(["relative flex items-center", @class])}
    >
      <input
        type="color"
        id={"#{@id}-picker"}
        value={@color_value}
        aria-label="Choose color"
        data-mui-color-picker
        tabindex="-1"
        class="absolute left-1.5 size-5 cursor-pointer opacity-0"
        disabled={@rest[:disabled]}
      />
      <button
        type="button"
        aria-label="Choose color"
        data-mui-color-trigger
        class="absolute left-1.5 size-5 rounded-mui-sm border border-mui-border bg-mui-foreground shadow-mui-xs disabled:cursor-not-allowed disabled:opacity-50"
        style={@color_value && "background-color: #{@color_value}"}
        disabled={@rest[:disabled]}
      />
      <input
        type="text"
        id={@id}
        phx-hook=".MUIColorInput"
        name={@name}
        value={@color_value}
        aria-invalid={to_string(@invalid)}
        data-mui-color-value
        data-mui-control
        class={[
          "mui-input h-8 w-full rounded-mui-md border border-transparent bg-mui-input-background pl-9 pr-3 font-mono text-sm text-mui-foreground",
          "placeholder:text-mui-input-placeholder focus-visible:border-mui-brand focus-visible:ring-2 focus-visible:ring-mui-slider-ring disabled:cursor-not-allowed disabled:opacity-50",
          @invalid && "border-mui-danger focus-visible:ring-mui-danger/30"
        ]}
        {@rest}
      />
    </div>
    """
  end

  defp normalize_color(nil), do: nil
  defp normalize_color(value), do: to_string(value)

  attr :rest, :global

  def hook(assigns) do
    ~H"""
    <script :type={Phoenix.LiveView.ColocatedHook} name=".MUIColorInput">
      export default {
        mounted() {
          const value = this.el
          const root = value.closest("[data-mui]")
          const picker = root.querySelector("[data-mui-color-picker]")
          const trigger = root.querySelector("[data-mui-color-trigger]")
          const validHex = (color) => /^#[0-9a-f]{6}$/i.test(color)

          const apply = (color, dispatch) => {
            if (!validHex(color)) return
            picker.value = color
            value.value = color.toUpperCase()
            trigger.style.backgroundColor = color
            value.setCustomValidity("")
            if (dispatch) {
              value.dispatchEvent(new Event("input", { bubbles: true }))
              value.dispatchEvent(new Event("change", { bubbles: true }))
            }
          }

          trigger.addEventListener("click", () => {
            if (picker.showPicker) picker.showPicker()
            else picker.click()
          })

          picker.addEventListener("input", () => apply(picker.value, true))
          value.addEventListener("input", () => {
            const color = value.value.trim()
            value.setCustomValidity(validHex(color) ? "" : "Enter a six-digit hex color")
            if (validHex(color)) apply(color, false)
          })
        }
      }
    </script>
    """
  end
end
