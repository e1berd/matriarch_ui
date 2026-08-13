defmodule MatriarchUIDocsWeb.Examples.Separator do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      title="Horizontal"
      class="flex-col"
      code={
        ~S'''
        <p>Above</p>
        <.separator />
        <p>Below</p>
        '''
      }
    >
      <p class="text-mui-foreground">Above</p>
      <.separator />
      <p class="text-mui-foreground">Below</p>
    </.example>

    <.example
      title="Vertical"
      code={
        ~S'''
        <span>Left</span>
        <.separator orientation="vertical" class="h-5" />
        <span>Right</span>
        '''
      }
    >
      <span class="text-mui-foreground">Left</span>
      <.separator orientation="vertical" class="h-5" />
      <span class="text-mui-foreground">Right</span>
    </.example>

    <.props_table rows={[
      {"orientation", "horizontal | vertical", "axis of the line"},
      {"class", "string", "merged with the default classes via CN.cn/1"}
    ]} />
    """
  end
end
