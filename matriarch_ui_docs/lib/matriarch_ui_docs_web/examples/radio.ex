defmodule MatriarchUIDocsWeb.Examples.Radio do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      locale={@locale}
      title="Field usage"
      code={
        ~S'''
        <.field :let={id} id="updates" orientation="horizontal">
          <.radio id={id} name="updates" value="enabled" checked />
          <.field_label for={id}>Email updates</.field_label>
        </.field>
        '''
      }
    >
      <.field :let={id} id="updates" orientation="horizontal">
        <.radio id={id} name="updates" value="enabled" checked />
        <.field_label for={id}>Email updates</.field_label>
      </.field>
    </.example>

    <.props_table
      locale={@locale}
      rows={[
        {"field", "Phoenix.HTML.FormField", "binds name/id and the selected form value"},
        {"checked", "boolean", "explicit checked state"},
        {"value", "any", "submitted option value"},
        {"invalid", "boolean", "danger state and aria-invalid"},
        {"class", "string", "merged with the default control classes"}
      ]}
    />
    """
  end
end
