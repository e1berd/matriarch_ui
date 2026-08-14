defmodule MatriarchUIDocsWeb.Examples.Popover do
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
        <.popover id="share" placement="bottom-start">
          <:trigger><.button variant="outline">Share</.button></:trigger>
          <p class="font-semibold text-mui-foreground">Share this page</p>
          <p class="mt-1 text-mui-muted-foreground">Anyone with the link can view it.</p>
        </.popover>
        '''
      }
    >
      <.popover id="share" placement="bottom-start">
        <:trigger><.button variant="outline">Share</.button></:trigger>
        <p class="font-semibold text-mui-foreground">Share this page</p>
        <p class="mt-1 text-mui-muted-foreground">Anyone with the link can view it.</p>
      </.popover>
    </.example>

    <.props_table
      locale={@locale}
      rows={[
        {"id", "string, required", "unique id for the trigger/panel pair"},
        {"placement", "string", "any .MUIFloating placement, defaults to \"bottom-start\""},
        {"trigger", "slot, required", "the clickable trigger content"}
      ]}
    />
    """
  end
end
