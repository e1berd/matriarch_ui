defmodule MatriarchUIDocsWeb.Examples.Pagination do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      title="Basic"
      description="Every button fires phx-click={event} phx-value-page={n} — handle it in your LiveView and re-render with the new page."
      code={
        ~S'''
        <.pagination page={4} total_pages={12} event="paginate" />
        '''
      }
    >
      <.pagination page={4} total_pages={12} event="paginate" />
    </.example>

    <.props_table rows={[
      {"page", "integer, required", "current page, 1-indexed"},
      {"total_pages", "integer, required", "total number of pages"},
      {"siblings", "integer", "page numbers shown on each side of the current page, default 1"},
      {"event", "string", "phx-click event name, default \"paginate\""},
      {"target", "any", "phx-target, e.g. @myself in a LiveComponent"}
    ]} />
    """
  end
end
