defmodule MatriarchUIDocsWeb.Examples.DateInput do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      title="Localized date input"
      class="flex-col items-stretch"
      code={
        ~S'''
        <.field :let={id} id="birthday">
          <.field_label for={id}>Birthday</.field_label>
          <.date_input
            id={id}
            name="birthday"
            value={~D[1994-05-23]}
            min={~D[1900-01-01]}
            max={Date.utc_today()}
          />
        </.field>
        '''
      }
    >
      <div class="w-72">
        <.field :let={id} id="birthday">
          <.field_label for={id}>Birthday</.field_label>
          <.date_input
            id={id}
            name="birthday"
            value={~D[1994-05-23]}
            min={~D[1900-01-01]}
            max={Date.utc_today()}
          />
        </.field>
      </div>
    </.example>

    <.props_table rows={[
      {"field", "Phoenix.HTML.FormField", "binds name/id/value and validation state"},
      {"min / max", "Date | ISO string", "inclusive native date constraints"},
      {"rest", "global attrs", "supports disabled, readonly, required, and step"},
      {"class", "string", "merged with the default input classes"}
    ]} />
    """
  end
end
