defmodule MatriarchUIDocsWeb.Examples.Listbox do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      title="Single select"
      code={
        ~S'''
        <.listbox id="fruit" name="fruit" value="apple">
          <:option value="apple">Apple</:option>
          <:option value="banana">Banana</:option>
          <:option value="cherry">Cherry</:option>
        </.listbox>
        '''
      }
    >
      <div class="w-56">
        <.listbox id="fruit" name="fruit" value="apple">
          <:option value="apple">Apple</:option>
          <:option value="banana">Banana</:option>
          <:option value="cherry">Cherry</:option>
        </.listbox>
      </div>
    </.example>

    <.example
      title="Multiple select"
      code={
        ~S'''
        <.listbox id="toppings" name="toppings[]" value={["olives"]} multiple>
          <:option value="olives">Olives</:option>
          <:option value="mushrooms">Mushrooms</:option>
          <:option value="peppers">Peppers</:option>
        </.listbox>
        '''
      }
    >
      <div class="w-56">
        <.listbox id="toppings" name="toppings[]" value={["olives"]} multiple>
          <:option value="olives">Olives</:option>
          <:option value="mushrooms">Mushrooms</:option>
          <:option value="peppers">Peppers</:option>
        </.listbox>
      </div>
    </.example>

    <.props_table rows={[
      {"field", "Phoenix.HTML.FormField", "binds name/value from a form"},
      {"multiple", "boolean", "checkboxes instead of radios; value is a list"},
      {"option", "slot, required",
       "one per row; each is a native radio/checkbox wrapped in its own label"}
    ]} />
    """
  end
end
