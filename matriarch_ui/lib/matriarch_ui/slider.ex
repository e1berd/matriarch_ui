defmodule MatriarchUI.Slider do
  @moduledoc "Single-value range slider — a styled native `<input type=\"range\">`, no JS required for layout."
  use Phoenix.Component
  alias MatriarchUI.CN

  attr :field, Phoenix.HTML.FormField
  attr :name, :any, default: nil
  attr :id, :any, default: nil
  attr :value, :any, default: 50
  attr :min, :any, default: 0
  attr :max, :any, default: 100
  attr :step, :any, default: 1
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled required)

  def slider(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil)
    |> assign_new(:name, fn -> field.name end)
    |> assign_new(:id, fn -> field.id end)
    |> assign_new(:value, fn -> field.value end)
    |> slider()
  end

  def slider(assigns) do
    ~H"""
    <input
      type="range"
      id={@id}
      name={@name}
      value={@value}
      min={@min}
      max={@max}
      step={@step}
      data-mui
      phx-hook=".MUISlider"
      style={"--mui-slider-fill: #{fill_percent(@value, @min, @max)}%"}
      class={CN.cn(["mui-slider", @class])}
      {@rest}
    />
    """
  end

  defp fill_percent(value, min, max) do
    min = to_number(min, 0)
    max = to_number(max, 100)
    range = max - min

    if range > 0 do
      100 * (to_number(value, min) - min) / range
    else
      0
    end
  end

  defp to_number(value, default) do
    case Float.parse(to_string(value)) do
      {number, _} -> number
      :error -> default
    end
  end

  attr :rest, :global

  def hook(assigns) do
    ~H"""
    <script :type={Phoenix.LiveView.ColocatedHook} name=".MUISlider">
      export default {
        mounted() {
          const input = this.el

          const update = () => {
            const min = parseFloat(input.min || "0")
            const max = parseFloat(input.max || "100")
            const value = parseFloat(input.value)
            const percent = max > min ? ((value - min) / (max - min)) * 100 : 0
            input.style.setProperty("--mui-slider-fill", `${percent}%`)
          }

          input.addEventListener("input", update)
        }
      }
    </script>
    """
  end
end
