defmodule MatriarchUIDocsWeb.Examples.Switch do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      title="Basic"
      code={
        ~S'''
        <.switch name="notify" id="notify" label="Email notifications" />
        <.switch name="notify2" id="notify2" label="On" checked />
        '''
      }
    >
      <.switch name="notify" id="notify" label="Email notifications" />
      <.switch name="notify2" id="notify2" label="On" checked />
    </.example>

    <.props_table rows={[
      {"field", "Phoenix.HTML.FormField", "binds name/id/checked from a form"},
      {"label", "string", "text next to the switch"},
      {"checked", "boolean", "initial checked state"},
      {"class", "string", "merged with the default classes via CN.cn/1"}
    ]} />
    """
  end
end
