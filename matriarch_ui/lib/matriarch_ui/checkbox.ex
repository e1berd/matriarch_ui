defmodule MatriarchUI.Checkbox do
  @moduledoc "Checkbox, usable standalone or bound to a `Phoenix.HTML.FormField`."
  use Phoenix.Component
  alias MatriarchUI.CN

  attr :field, Phoenix.HTML.FormField
  attr :label, :string, default: nil
  attr :name, :any, default: nil
  attr :id, :any, default: nil
  attr :checked, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled required)

  def checkbox(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, checked: Phoenix.HTML.Form.normalize_value("checkbox", field.value))
    |> assign_new(:name, fn -> field.name end)
    |> assign_new(:id, fn -> field.id end)
    |> checkbox()
  end

  def checkbox(assigns) do
    ~H"""
    <label data-mui for={@id} class="inline-flex items-center gap-2 text-sm text-mui-foreground">
      <input type="hidden" name={@name} value="false" disabled={@rest[:disabled]} />
      <input
        type="checkbox"
        name={@name}
        id={@id}
        value="true"
        checked={@checked}
        class={
          CN.cn([
            "size-4 rounded-[4px] border-mui-border-strong text-mui-primary accent-mui-primary",
            "focus-visible:ring-2 focus-visible:ring-mui-ring/30 disabled:cursor-not-allowed disabled:opacity-50",
            @class
          ])
        }
        {@rest}
      />
      {@label}
    </label>
    """
  end
end
