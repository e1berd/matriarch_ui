defmodule MatriarchUIDocsWeb.Examples.PhoneInput do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    assigns = Map.put_new(assigns, :locale, "en")

    ~H"""
    <.example
      title="Region and unmasked number"
      class="flex-col items-stretch"
      code={
        ~S'''
        <.field :let={id} id="mobile">
          <.field_label for={id}>Phone</.field_label>
          <.phone_input
            id={id}
            name="phone"
            region="FI"
            locale={@locale}
            placeholder="+358 40 123 4567"
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
            locale={@locale}
            placeholder="+358 40 123 4567"
          />
        </.field>
      </div>
    </.example>

    <.props_table rows={[
      {"field", "Phoenix.HTML.FormField", "binds the telephone value and validation state"},
      {"region / region_name", "string", "selected ISO region and the separate submitted field name"},
      {"regions", "list", "ISO regions shown in the selector; defaults to the complete list"},
      {"calling_codes", "map", "region to international-prefix overrides"},
      {"locale", "string", "locale used for region names; defaults to the document locale"},
      {"class", "string", "merged with the joined control classes"}
    ]} />
    """
  end
end
