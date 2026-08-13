defmodule MatriarchUI.Switch do
  @moduledoc "Toggle switch, usable standalone or bound to a `Phoenix.HTML.FormField`."
  use Phoenix.Component
  alias MatriarchUI.CN

  attr :field, Phoenix.HTML.FormField
  attr :label, :string, default: nil
  attr :name, :any, default: nil
  attr :id, :any, default: nil
  attr :checked, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled required)

  def switch(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, checked: Phoenix.HTML.Form.normalize_value("checkbox", field.value))
    |> assign_new(:name, fn -> field.name end)
    |> assign_new(:id, fn -> field.id end)
    |> switch()
  end

  def switch(assigns) do
    ~H"""
    <label data-mui for={@id} class="inline-flex items-center gap-2 text-sm text-mui-foreground">
      <input type="hidden" name={@name} value="false" disabled={@rest[:disabled]} />
      <span class="relative inline-flex h-6 w-11 shrink-0 items-center">
        <input
          type="checkbox"
          name={@name}
          id={@id}
          value="true"
          checked={@checked}
          class={CN.cn(["peer sr-only", @class])}
          {@rest}
        />
        <span class={[
          "absolute inset-0 rounded-mui-full bg-mui-border-strong transition-colors",
          "peer-checked:bg-mui-primary peer-focus-visible:ring-2 peer-focus-visible:ring-mui-ring/30",
          "peer-disabled:cursor-not-allowed peer-disabled:opacity-50"
        ]}>
        </span>
        <span class="pointer-events-none absolute left-0.5 size-5 rounded-mui-full bg-white shadow-mui-sm transition-transform peer-checked:translate-x-5">
        </span>
      </span>
      {@label}
    </label>
    """
  end
end
