defmodule MatriarchUI.RadioGroup do
  @moduledoc "A set of mutually exclusive radio options bound to a `Phoenix.HTML.FormField`."
  use Phoenix.Component
  alias MatriarchUI.CN

  attr :field, Phoenix.HTML.FormField
  attr :name, :any, default: nil
  attr :id, :any, default: nil
  attr :value, :any, default: nil
  attr :label, :string, default: nil
  attr :options, :list, required: true, doc: "list of `{label, value}` tuples"
  attr :orientation, :string, default: "vertical", values: ~w(vertical horizontal)
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled required)

  def radio_group(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil)
    |> assign_new(:name, fn -> field.name end)
    |> assign_new(:id, fn -> field.id end)
    |> assign_new(:value, fn -> field.value end)
    |> radio_group()
  end

  def radio_group(assigns) do
    ~H"""
    <fieldset data-mui class="flex flex-col gap-2">
      <legend :if={@label} class="mb-1 text-sm font-medium text-mui-foreground">{@label}</legend>
      <div class={
        CN.cn([
          "flex gap-3",
          if(@orientation == "vertical", do: "flex-col", else: "flex-row flex-wrap"),
          @class
        ])
      }>
        <label
          :for={{option_label, option_value} <- @options}
          for={"#{@id}-#{option_value}"}
          class="inline-flex items-center gap-2 text-sm text-mui-foreground"
        >
          <input
            type="radio"
            name={@name}
            id={"#{@id}-#{option_value}"}
            value={option_value}
            checked={to_string(@value) == to_string(option_value)}
            class="size-4 border-mui-border-strong text-mui-primary accent-mui-primary focus-visible:ring-2 focus-visible:ring-mui-ring/30 disabled:cursor-not-allowed disabled:opacity-50"
            {@rest}
          />
          {option_label}
        </label>
      </div>
    </fieldset>
    """
  end
end
