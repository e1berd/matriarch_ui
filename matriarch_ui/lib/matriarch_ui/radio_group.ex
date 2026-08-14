defmodule MatriarchUI.RadioGroup do
  @moduledoc "A set of mutually exclusive radio options bound to a `Phoenix.HTML.FormField`."
  use Phoenix.Component
  alias MatriarchUI.CN
  import MatriarchUI.Radio

  attr :field, Phoenix.HTML.FormField
  attr :name, :any, default: nil
  attr :id, :any, default: nil
  attr :value, :any, default: nil
  attr :label, :string, default: nil
  attr :options, :list, required: true, doc: "list of `{label, value}` tuples"
  attr :orientation, :string, default: "vertical", values: ~w(vertical horizontal)
  attr :invalid, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled required)

  def radio_group(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(
      field: nil,
      invalid: used_input?(field) && field.errors != [],
      name: assigns.name || field.name,
      id: assigns.id || field.id,
      value: if(is_nil(assigns.value), do: field.value, else: assigns.value)
    )
    |> radio_group()
  end

  def radio_group(assigns) do
    ~H"""
    <fieldset data-mui class={CN.cn(["flex flex-col gap-2", @class])}>
      <legend :if={@label} class="mb-1 text-sm font-medium text-mui-foreground">{@label}</legend>
      <div class={
        CN.cn([
          "flex gap-3",
          if(@orientation == "vertical", do: "flex-col", else: "flex-row flex-wrap"),
          nil
        ])
      }>
        <label
          :for={{option_label, option_value} <- @options}
          for={"#{@id}-#{option_value}"}
          class="inline-flex items-center gap-2 text-sm text-mui-foreground"
        >
          <.radio
            name={@name}
            id={"#{@id}-#{option_value}"}
            value={option_value}
            checked={to_string(@value) == to_string(option_value)}
            invalid={@invalid}
            {@rest}
          />
          {option_label}
        </label>
      </div>
    </fieldset>
    """
  end
end
