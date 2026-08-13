defmodule MatriarchUIDocsWeb.Examples.Tooltip do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      title="Placements"
      code={
        ~S'''
        <.tooltip id="tip-top" text="Top" placement="top">
          <.button variant="outline" size="sm">Top</.button>
        </.tooltip>
        <.tooltip id="tip-right" text="Right" placement="right">
          <.button variant="outline" size="sm">Right</.button>
        </.tooltip>
        <.tooltip id="tip-bottom" text="Bottom" placement="bottom">
          <.button variant="outline" size="sm">Bottom</.button>
        </.tooltip>
        '''
      }
    >
      <.tooltip id="tip-top" text="Top" placement="top">
        <.button variant="outline" size="sm">Top</.button>
      </.tooltip>
      <.tooltip id="tip-right" text="Right" placement="right">
        <.button variant="outline" size="sm">Right</.button>
      </.tooltip>
      <.tooltip id="tip-bottom" text="Bottom" placement="bottom">
        <.button variant="outline" size="sm">Bottom</.button>
      </.tooltip>
    </.example>

    <.props_table rows={[
      {"id", "string, required", "unique id for the trigger/panel pair"},
      {"text", "string, required", "tooltip content"},
      {"placement", "string", "any .MUIFloating placement, defaults to \"top\""}
    ]} />
    """
  end
end
