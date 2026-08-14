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
        <div class="w-64">
          <div class="mb-2 flex items-center justify-between text-sm">
            <label for="volume" class="font-medium text-mui-foreground">Volume</label>
            <span class="text-mui-muted-foreground">40</span>
          </div>
          <.slider name="volume" id="volume" value={40} />
        </div>
        '''
      }
    >
      <div class="w-64">
        <div class="mb-2 flex items-center justify-between text-sm">
          <label for="volume" class="font-medium text-mui-foreground">Volume</label>
          <span class="text-mui-muted-foreground">40</span>
        </div>
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
