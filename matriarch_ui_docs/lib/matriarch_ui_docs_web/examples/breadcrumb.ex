defmodule MatriarchUIDocsWeb.Examples.Breadcrumb do
  use Phoenix.Component

  use Phoenix.VerifiedRoutes,
    endpoint: MatriarchUIDocsWeb.Endpoint,
    router: MatriarchUIDocsWeb.Router

  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      title="Basic"
      code={
        ~S'''
        <.breadcrumb>
          <:item navigate={~p"/"}>Home</:item>
          <:item navigate={~p"/docs"}>Docs</:item>
          <:item>Breadcrumb</:item>
        </.breadcrumb>
        '''
      }
    >
      <.breadcrumb>
        <:item navigate={~p"/"}>Home</:item>
        <:item navigate={~p"/docs"}>Docs</:item>
        <:item>Breadcrumb</:item>
      </.breadcrumb>
    </.example>

    <.props_table rows={[
      {"item", "slot, required",
       "one per crumb; accepts navigate/patch/href. The last item is always rendered as the current page (no link)."},
      {"class", "string", "merged with the default classes via CN.cn/1"}
    ]} />
    """
  end
end
