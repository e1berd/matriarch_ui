defmodule MatriarchUIDocsWeb.Examples.Slider do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      title="Basic"
      code={
        ~S'''
        <.slider name="volume" id="volume" value={40} />
        '''
      }
    >
      <div class="w-64">
        <.slider name="volume" id="volume" value={40} />
      </div>
    </.example>

    <.props_table rows={[
      {"field", "Phoenix.HTML.FormField", "binds name/id/value from a form"},
      {"min / max / step", "number", "defaults 0 / 100 / 1"},
      {"class", "string", "merged with the default classes via CN.cn/1"}
    ]} />
    """
  end
end
