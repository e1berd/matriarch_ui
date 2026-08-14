defmodule MatriarchUIDocsWeb.Examples.NumberInput do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      title="Bounded and scrubbable"
      description="Hold either step button, use ArrowUp/ArrowDown, or drag horizontally over the input. Every interaction respects min, max, and step."
      class="flex-col items-stretch"
      code={
        ~S'''
        <.field :let={id} id="quantity">
          <.field_label for={id}>Quantity</.field_label>
          <.number_input id={id} name="quantity" value={12} min={0} max={100} step={2} />
        </.field>
        '''
      }
    >
      <div class="w-72">
        <.field :let={id} id="quantity">
          <.field_label for={id}>Quantity</.field_label>
          <.number_input id={id} name="quantity" value={12} min={0} max={100} step={2} />
        </.field>
      </div>
    </.example>

    <.example
      title="Formatted raw value"
      description="The visible value uses the mask and currency suffix, while the submitted value remains 100000."
      class="flex-col items-stretch"
      code={
        ~S'''
        <.number_input
          id="budget"
          name="budget"
          value={100_000}
          min={0}
          step={1_000}
          mask="### ###"
          suffix="₽"
        />
        '''
      }
    >
      <div class="w-72">
        <.number_input
          id="budget"
          name="budget"
          value={100_000}
          min={0}
          step={1_000}
          mask="### ###"
          suffix="₽"
        />
      </div>
    </.example>

    <.props_table rows={[
      {"field", "Phoenix.HTML.FormField", "binds the raw numeric value and validation state"},
      {"min / max / step", "number", "bounds and increment used by every interaction"},
      {"mask", "string", "visual digit mask where # is a digit, for example ### ###"},
      {"decimal_separator", "string", "visible decimal separator, default ."},
      {"prefix / suffix", "string", "visual units that are excluded from the submitted value"},
      {"class", "string", "merged with the control classes via CN.cn/1"}
    ]} />
    """
  end
end
