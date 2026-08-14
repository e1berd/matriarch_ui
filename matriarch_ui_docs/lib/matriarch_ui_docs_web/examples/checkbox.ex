defmodule MatriarchUIDocsWeb.Examples.Checkbox do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      title="Basic"
      code={
        ~S'''
        <.field id="tos" class="flex-row items-center gap-2" :let={id}>
          <.checkbox id={id} name="tos" />
          <.field_label for={id}>Accept the terms</.field_label>
        </.field>
        <.field id="tos2" class="flex-row items-center gap-2" :let={id}>
          <.checkbox id={id} name="tos2" checked />
          <.field_label for={id}>Checked</.field_label>
        </.field>
        <.field id="tos3" class="flex-row items-center gap-2" :let={id}>
          <.checkbox id={id} name="tos3" indeterminate />
          <.field_label for={id}>Indeterminate</.field_label>
        </.field>
        '''
      }
    >
      <.field :let={id} id="tos" class="flex-row items-center gap-2">
        <.checkbox id={id} name="tos" />
        <.field_label for={id}>Accept the terms</.field_label>
      </.field>
      <.field :let={id} id="tos2" class="flex-row items-center gap-2">
        <.checkbox id={id} name="tos2" checked />
        <.field_label for={id}>Checked</.field_label>
      </.field>
      <.field :let={id} id="tos3" class="flex-row items-center gap-2">
        <.checkbox id={id} name="tos3" indeterminate />
        <.field_label for={id}>Indeterminate</.field_label>
      </.field>
    </.example>

    <.props_table rows={[
      {"field", "Phoenix.HTML.FormField", "binds name/id/checked from a form"},
      {"checked", "boolean", "initial checked state"},
      {"indeterminate", "boolean", "renders the mixed state with a minus indicator"},
      {"class", "string", "merged with the default classes via CN.cn/1"}
    ]} />
    """
  end
end
