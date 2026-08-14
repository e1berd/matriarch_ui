defmodule MatriarchUIDocsWeb.Examples.Switch do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      locale={@locale}
      title="Basic"
      code={
        ~S'''
        <.field :let={id} id="notify" orientation="horizontal">
          <.switch id={id} name="notify" />
          <.field_label for={id}>Email notifications</.field_label>
        </.field>
        <.field :let={id} id="notify2" orientation="horizontal">
          <.switch id={id} name="notify2" checked />
          <.field_label for={id}>On</.field_label>
        </.field>
        '''
      }
    >
      <.field :let={id} id="notify" orientation="horizontal">
        <.switch id={id} name="notify" />
        <.field_label for={id}>Email notifications</.field_label>
      </.field>
      <.field :let={id} id="notify2" orientation="horizontal">
        <.switch id={id} name="notify2" checked />
        <.field_label for={id}>On</.field_label>
      </.field>
    </.example>

    <.props_table
      locale={@locale}
      rows={[
        {"field", "Phoenix.HTML.FormField", "binds name/id/checked from a form"},
        {"checked", "boolean", "initial checked state"},
        {"class", "string", "merged with the default classes via CN.cn/1"}
      ]}
    />
    """
  end
end
