defmodule MatriarchUIDocsWeb.Examples.ScrollArea do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      title="Basic"
      code={
        ~S'''
        <.scroll_area class="h-40 w-64 rounded-mui-lg border border-mui-border p-3">
          <p :for={i <- 1..20} class="text-sm text-mui-foreground">Row {i}</p>
        </.scroll_area>
        '''
      }
    >
      <.scroll_area class="h-40 w-64 rounded-mui-lg border border-mui-border p-3">
        <p :for={i <- 1..20} class="text-sm text-mui-foreground">Row {i}</p>
      </.scroll_area>
    </.example>

    <.props_table rows={[
      {"orientation", "vertical | horizontal | both", "which axis scrolls, defaults to vertical"},
      {"class", "string", "merged with the default classes via CN.cn/1 — set height/width here"}
    ]} />
    """
  end
end
