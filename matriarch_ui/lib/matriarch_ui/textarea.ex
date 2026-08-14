defmodule MatriarchUI.Textarea do
  @moduledoc "Bare multi-line text input — pair with `MatriarchUI.Field` for a label and validation errors."
  use Phoenix.Component
  alias MatriarchUI.CN

  attr :field, Phoenix.HTML.FormField
  attr :name, :any, default: nil
  attr :id, :any, default: nil
  attr :value, :any, default: nil
  attr :invalid, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(placeholder disabled readonly required rows)

  def textarea(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, invalid: used_input?(field) && field.errors != [])
    |> assign_new(:name, fn -> field.name end)
    |> assign_new(:id, fn -> field.id end)
    |> assign_new(:value, fn -> field.value end)
    |> textarea()
  end

  def textarea(assigns) do
    ~H"""
    <textarea
      data-mui
      data-mui-control
      name={@name}
      id={@id}
      aria-invalid={to_string(@invalid)}
      class={
        CN.cn([
          "min-h-24 w-full rounded-mui-md border border-mui-border bg-mui-surface px-3 py-2 text-sm text-mui-foreground",
          "placeholder:text-mui-input-placeholder focus-visible:border-mui-primary focus-visible:ring-2 focus-visible:ring-mui-ring/30",
          "disabled:cursor-not-allowed disabled:opacity-50",
          @invalid && "border-mui-danger focus-visible:ring-mui-danger/30",
          @class
        ])
      }
      {@rest}
    >{Phoenix.HTML.Form.normalize_value("textarea", @value)}</textarea>
    """
  end
end
