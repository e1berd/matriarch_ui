defmodule MatriarchUIDocsWeb.Examples.Alert do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      title="Variants"
      class="flex-col items-stretch"
      code={
        ~S'''
        <.alert>Heads up — this is an informational message.</.alert>
        <.alert variant="success" title="Saved">Your changes were saved.</.alert>
        <.alert variant="warning" title="Careful">This action can't be undone.</.alert>
        <.alert variant="danger" title="Error">Something went wrong.</.alert>
        '''
      }
    >
      <.alert>Heads up — this is an informational message.</.alert>
      <.alert variant="success" title="Saved">Your changes were saved.</.alert>
      <.alert variant="warning" title="Careful">This action can't be undone.</.alert>
      <.alert variant="danger" title="Error">Something went wrong.</.alert>
    </.example>

    <.props_table rows={[
      {"variant", "info | success | warning | danger", "visual style"},
      {"title", "string", "optional bold heading above the message"},
      {"class", "string", "merged with the default classes via CN.cn/1"}
    ]} />
    """
  end
end
