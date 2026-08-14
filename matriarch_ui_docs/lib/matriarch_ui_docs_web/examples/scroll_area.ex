defmodule MatriarchUIDocsWeb.Examples.ScrollArea do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      locale={@locale}
      title="Basic"
      code={
        ~S'''
        <.scroll_area
          id="activity-scroll-area"
          class="h-40 w-64 rounded-mui-lg border border-mui-border"
          content_class="space-y-1 p-3 pr-6"
        >
          <p :for={i <- 1..20} class="text-sm text-mui-foreground">Row {i}</p>
        </.scroll_area>
        '''
      }
    >
      <.scroll_area
        id="activity-scroll-area"
        class="h-40 w-64 rounded-mui-lg border border-mui-border"
        content_class="space-y-1 p-3 pr-6"
      >
        <p :for={i <- 1..20} class="text-sm text-mui-foreground">Row {i}</p>
      </.scroll_area>
    </.example>

    <.props_table
      locale={@locale}
      rows={[
        {"id", "string, required", "unique DOM id for the scroll behavior hook"},
        {"orientation", "vertical | horizontal | both", "which axis scrolls, defaults to vertical"},
        {"class", "string", "classes for the outer root — set height and width here"},
        {"viewport_class", "string", "classes merged into the scrollable viewport"},
        {"content_class", "string", "classes merged into the content container"}
      ]}
    />
    """
  end
end
