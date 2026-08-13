defmodule MatriarchUIDocsWeb.Examples.Badge do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      title="Variants"
      code={
        ~S'''
        <.badge>Neutral</.badge>
        <.badge variant="primary">Primary</.badge>
        <.badge variant="success">Success</.badge>
        <.badge variant="warning">Warning</.badge>
        <.badge variant="danger">Danger</.badge>
        <.badge variant="outline">Outline</.badge>
        '''
      }
    >
      <.badge>Neutral</.badge>
      <.badge variant="primary">Primary</.badge>
      <.badge variant="success">Success</.badge>
      <.badge variant="warning">Warning</.badge>
      <.badge variant="danger">Danger</.badge>
      <.badge variant="outline">Outline</.badge>
    </.example>

    <.props_table rows={[
      {"variant", "neutral | primary | success | warning | danger | outline", "visual style"},
      {"class", "string", "merged with the default classes via CN.cn/1"}
    ]} />
    """
  end
end
