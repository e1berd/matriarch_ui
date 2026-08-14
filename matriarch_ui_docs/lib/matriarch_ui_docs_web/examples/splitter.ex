defmodule MatriarchUIDocsWeb.Examples.Splitter do
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
        <.splitter id="layout" class="h-48 rounded-mui-lg border border-mui-border">
          <:panel default_size={30}>
            <div class="h-full p-3 text-sm text-mui-foreground">Sidebar</div>
          </:panel>
          <:panel>
            <div class="h-full p-3 text-sm text-mui-foreground">Content</div>
          </:panel>
        </.splitter>
        '''
      }
    >
      <.splitter id="layout" class="h-48 rounded-mui-lg border border-mui-border">
        <:panel default_size={30}>
          <div class="h-full p-3 text-sm text-mui-foreground">Sidebar</div>
        </:panel>
        <:panel>
          <div class="h-full p-3 text-sm text-mui-foreground">Content</div>
        </:panel>
      </.splitter>
    </.example>

    <.props_table
      locale={@locale}
      rows={[
        {"orientation", "horizontal | vertical", "resize axis, defaults to horizontal"},
        {"storage_key", "string",
         "localStorage key panel sizes persist under and restore from, defaults to none"},
        {"panel", "slot, required",
         "one per pane; takes default_size (percent, defaults to an even split), min_size and max_size (percent, default to 0 and 100)"}
      ]}
    />
    """
  end
end
