defmodule MatriarchUI.Checkbox do
  @moduledoc "Bare checkbox — pair with `MatriarchUI.Field` + `field_label/1` for a label."
  use Phoenix.Component
  alias MatriarchUI.CN
  import MatriarchUI.Icon

  attr :field, Phoenix.HTML.FormField
  attr :name, :any, default: nil
  attr :id, :any, default: nil
  attr :checked, :boolean, default: false
  attr :indeterminate, :boolean, default: false
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
    <input type="hidden" name={@name} value="false" disabled={@rest[:disabled]} />
    <label
      data-mui
      data-mui-control
      class="relative inline-flex size-5 shrink-0 items-center justify-center align-middle"
    >
      <input
        type="checkbox"
        name={@name}
        id={@id}
        value="true"
        checked={@checked}
        aria-checked={@indeterminate && "mixed"}
        class="peer sr-only"
        {@rest}
      />
      <span
        class={
          CN.cn([
            "inline-flex size-5 items-center justify-center rounded-mui-sm border border-mui-checkbox-border bg-mui-checkbox-background",
            "peer-checked:border-mui-checkbox-checked peer-checked:bg-mui-checkbox-checked peer-checked:text-mui-checkbox-checked-foreground",
            "peer-focus-visible:ring-2 peer-focus-visible:ring-mui-ring/30 peer-disabled:cursor-not-allowed peer-disabled:opacity-50",
            @indeterminate &&
              "border-mui-checkbox-checked bg-mui-checkbox-checked text-mui-checkbox-checked-foreground",
            @class
          ])
        }
      >
      </span>
      <.icon
        :if={!@indeterminate}
        name="check"
        class="pointer-events-none absolute invisible size-4 text-mui-checkbox-checked-foreground peer-checked:visible"
      />
      <.icon
        :if={@indeterminate}
        name="minus"
        class="pointer-events-none absolute size-4 text-mui-checkbox-checked-foreground"
      />
    </label>
    """
  end
end
