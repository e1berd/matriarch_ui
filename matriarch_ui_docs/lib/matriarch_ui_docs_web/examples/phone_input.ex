defmodule MatriarchUIDocsWeb.Examples.PhoneInput do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      title="Compact region and protected prefix"
      class="flex-col items-stretch"
      code={
        ~S'''
        <.field :let={id} id="mobile">
          <.field_label for={id}>Phone</.field_label>
          <.phone_input
            id={id}
            name="phone"
            region="FI"
            placeholder="40 123 4567"
          />
        </.field>
        '''
      }
    >
      <div class="w-96">
        <.field :let={id} id="mobile">
          <.field_label for={id}>Phone</.field_label>
          <.phone_input
            id={id}
            name="phone"
            region="FI"
            placeholder="40 123 4567"
          />
        </.field>
      </div>
    </.example>

    <.props_table rows={[
      {"field", "Phoenix.HTML.FormField", "binds the telephone value and validation state"},
      {"region / region_name", "string", "selected ISO region and the separate submitted field name"},
      {"regions", "list", "ISO regions shown in the selector; defaults to the complete list"},
      {"calling_codes", "map", "region to international-prefix overrides"},
      {"class", "string", "merged with the joined control classes"}
    ]} />
    """
  end
end
