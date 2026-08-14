defmodule MatriarchUI.Input do
  @moduledoc "Bare text input — pair with `MatriarchUI.Field` for a label and validation errors."
  use Phoenix.Component
  alias MatriarchUI.CN

  attr :field, Phoenix.HTML.FormField
  attr :type, :string, default: "text"
  attr :name, :any, default: nil
  attr :id, :any, default: nil
  attr :value, :any, default: nil
  attr :invalid, :boolean, default: false
  attr :class, :string, default: nil

  attr :rest, :global,
    include: ~w(placeholder autocomplete disabled readonly required min max step)

  slot :leading

  def input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, invalid: used_input?(field) && field.errors != [])
    |> assign_new(:name, fn -> field.name end)
    |> assign_new(:id, fn -> field.id end)
    |> assign_new(:value, fn -> field.value end)
    |> input()
  end

  def input(assigns) do
    ~H"""
    <div data-mui class="relative flex items-center">
      <span
        :if={@leading != []}
        class="pointer-events-none absolute left-3 flex size-4 items-center text-mui-subtle-foreground"
      >
        {render_slot(@leading)}
      </span>
      <input
        type={@type}
        name={@name}
        id={@id}
        value={Phoenix.HTML.Form.normalize_value(@type, @value)}
        aria-invalid={to_string(@invalid)}
        class={
          CN.cn([
            "mui-input h-8 w-full rounded-mui-md border border-transparent bg-mui-input-background px-3 text-sm text-mui-foreground",
            "placeholder:text-mui-input-placeholder focus-visible:border-mui-brand focus-visible:ring-2 focus-visible:ring-mui-slider-ring",
            "disabled:cursor-not-allowed disabled:opacity-50",
            @leading != [] && "pl-9",
            @invalid && "border-mui-danger focus-visible:ring-mui-danger/30",
            @class
          ])
        }
        {@rest}
      />
    </div>
    """
  end
end
