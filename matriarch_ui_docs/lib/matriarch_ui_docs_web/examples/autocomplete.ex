defmodule MatriarchUIDocsWeb.Examples.Autocomplete do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      title="Basic"
      description="Wire your own phx-change/phx-debounce to filter :option server-side as the user types."
      code={
        ~S'''
        <.field id="city" :let={id}>
          <.field_label for={id}>City</.field_label>
          <.autocomplete id={id} name="city" placeholder="Search a city…">
            <:option value="Berlin">Berlin</:option>
            <:option value="Bern">Bern</:option>
            <:option value="Boston">Boston</:option>
          </.autocomplete>
        </.field>
        '''
      }
    >
      <div class="w-64">
        <.field :let={id} id="city">
          <.field_label for={id}>City</.field_label>
          <.autocomplete id={id} name="city" placeholder="Search a city…">
            <:option value="Berlin">Berlin</:option>
            <:option value="Bern">Bern</:option>
            <:option value="Boston">Boston</:option>
          </.autocomplete>
        </.field>
      </div>
    </.example>

    <.props_table rows={[
      {"field", "Phoenix.HTML.FormField", "binds name/value/invalid from a form"},
      {"option", "slot", "one per suggestion; takes value and an optional label"},
      {"placeholder", "string", "shown when the input is empty"},
      {"invalid", "boolean", "shows the danger border and aria-invalid"},
      {"rest", "phx-change, phx-keyup, phx-debounce, phx-target, disabled",
       "wire your own live filtering — the input's typed value is the form field, picking a suggestion fills it in"}
    ]} />
    """
  end
end
