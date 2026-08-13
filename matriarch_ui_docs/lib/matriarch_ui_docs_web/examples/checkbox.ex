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
        <.checkbox name="tos" id="tos" label="Accept the terms" />
        <.checkbox name="tos2" id="tos2" label="Checked" checked />
        '''
      }
    >
      <.checkbox name="tos" id="tos" label="Accept the terms" />
      <.checkbox name="tos2" id="tos2" label="Checked" checked />
    </.example>

    <.props_table rows={[
      {"field", "Phoenix.HTML.FormField", "binds name/id/checked from a form"},
      {"label", "string", "text next to the box"},
      {"checked", "boolean", "initial checked state"},
      {"class", "string", "merged with the default classes via CN.cn/1"}
    ]} />
    """
  end
end
