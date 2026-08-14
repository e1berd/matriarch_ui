defmodule MatriarchUIDocsWeb.Examples.Autocomplete do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      locale={@locale}
      title="Basic"
      description="The list opens on focus and filters locally as you type. Add phx-change/phx-debounce when suggestions come from the server."
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

    <.props_table
      locale={@locale}
      rows={[
        {"field", "Phoenix.HTML.FormField", "binds name/value/invalid from a form"},
        {"option", "slot", "one per suggestion; takes value and an optional label"},
        {"placeholder", "string", "shown when the input is empty"},
        {"invalid", "boolean", "shows the danger border and aria-invalid"},
        {"rest", "phx-change, phx-keyup, phx-debounce, phx-target, disabled",
         "optional server filtering — local filtering works without LiveView events"}
      ]}
    />
    """
  end
end
