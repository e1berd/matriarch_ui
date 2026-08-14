defmodule MatriarchUIDocsWeb.Examples.Pagination do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    assigns = Map.put_new(assigns, :page, 4)
    assigns = Map.put_new(assigns, :locale, "en")

    ~H"""
    <.example
      title="Basic"
      description="Use the arrows or enter a page directly. The input is clamped between 1 and total_pages."
      code={
        ~S'''
        <.pagination
          id="results-pagination"
          page={@page}
          total_pages={12}
          event="paginate"
          locale={@locale}
        >
          <:page_size>
            <div class="w-20">
              <.select id="results-page-size" name="page_size" value="10">
                <:option value="10">10</:option>
                <:option value="25">25</:option>
              </.select>
            </div>
          </:page_size>
        </.pagination>
        '''
      }
    >
      <.pagination
        id="results-pagination"
        page={@page}
        total_pages={12}
        event="paginate"
        locale={@locale}
      >
        <:page_size>
          <div class="w-20">
            <.select id="results-page-size" name="page_size" value="10">
              <:option value="10">10</:option>
              <:option value="25">25</:option>
            </.select>
          </div>
        </:page_size>
      </.pagination>
    </.example>

    <.props_table rows={[
      {"id", "string, required", "unique DOM id used by the navigation controls"},
      {"page", "integer, required", "current page, 1-indexed"},
      {"total_pages", "integer, required", "total number of pages"},
      {"event", "string", "phx-click event name, default \"paginate\""},
      {"target", "any", "phx-target, e.g. @myself in a LiveComponent"},
      {"locale", "en | ru", "translation locale loaded from the package YAML files"},
      {"page_size", "slot", "optional page-size control shown with a translated label"}
    ]} />
    """
  end
end
