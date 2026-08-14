defmodule MatriarchUI.DateInput do
  @moduledoc "Localized native date input with form field binding and date constraints."
  use Phoenix.Component
  alias MatriarchUI.CN

  attr :field, Phoenix.HTML.FormField
  attr :name, :any, default: nil
  attr :id, :any, default: nil
  attr :value, :any, default: nil
  attr :min, :any, default: nil
  attr :max, :any, default: nil
  attr :invalid, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(autocomplete disabled readonly required step)

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
    ~H"""
    <input
      data-mui
      data-mui-control
      type="date"
      name={@name}
      id={@id}
      value={normalize_date(@value)}
      min={normalize_date(@min)}
      max={normalize_date(@max)}
      aria-invalid={to_string(@invalid)}
      class={
        CN.cn([
          "mui-date-input mui-input h-8 w-full rounded-mui-md border border-transparent bg-mui-input-background px-3 text-sm text-mui-foreground",
          "focus-visible:border-mui-brand focus-visible:ring-2 focus-visible:ring-mui-slider-ring disabled:cursor-not-allowed disabled:opacity-50",
          @invalid && "border-mui-danger focus-visible:ring-mui-danger/30",
          @class
        ])
      }
      {@rest}
    />
    """
  end

  defp normalize_date(%Date{} = date), do: Date.to_iso8601(date)
  defp normalize_date(nil), do: nil
  defp normalize_date(value), do: to_string(value)
end
