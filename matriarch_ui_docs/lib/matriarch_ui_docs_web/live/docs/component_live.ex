defmodule MatriarchUIDocsWeb.Docs.ComponentLive do
  use MatriarchUIDocsWeb, :live_view
  alias MatriarchUIDocsWeb.{DocsSidebar, Registry}

  def mount(%{"slug" => slug}, _session, socket) do
    case Registry.fetch(slug) do
      nil ->
        {:ok, push_navigate(socket, to: ~p"/docs")}

      entry ->
        {:ok,
         assign(socket,
           page_title: entry.title,
           entry: entry,
           pagination_page: 4,
           table_page: 1,
           table_filters: %{"query" => "", "status" => ""}
         )}
    end
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="mx-auto flex max-w-6xl gap-2 px-6">
        <DocsSidebar.sidebar active={@entry.slug} />
        <div class="min-w-0 flex-1 border-l border-mui-border py-8 pl-7">
          <h1 class="text-2xl font-semibold tracking-tight text-mui-foreground">{@entry.title}</h1>
          <div class="mt-6 flex flex-col gap-8">
            {apply(@entry.module, :examples, [
              %{page: @pagination_page, table_page: @table_page, filters: @table_filters}
            ])}
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end

  def handle_event("paginate", %{"page" => page}, socket) do
    page = page |> parse_page() |> max(1) |> min(12)
    {:noreply, push_patch(socket, to: ~p"/docs/components/pagination?#{[page: page]}")}
  end

  def handle_event("filter-table", %{"filters" => filters}, socket) do
    params = [
      query: Map.get(filters, "query", ""),
      status: Map.get(filters, "status", ""),
      page: 1
    ]

    {:noreply, push_patch(socket, to: ~p"/docs/components/table?#{params}")}
  end

  def handle_event("paginate-table", %{"page" => page}, socket) do
    filters = socket.assigns.table_filters

    params = [
      query: Map.get(filters, "query", ""),
      status: Map.get(filters, "status", ""),
      page: max(parse_page(page), 1)
    ]

    {:noreply, push_patch(socket, to: ~p"/docs/components/table?#{params}")}
  end

  def handle_params(%{"page" => page}, _uri, %{assigns: %{entry: %{slug: "pagination"}}} = socket) do
    page = page |> parse_page() |> max(1) |> min(12)
    {:noreply, assign(socket, :pagination_page, page)}
  end

  def handle_params(params, _uri, %{assigns: %{entry: %{slug: "table"}}} = socket) do
    filters = %{
      "query" => Map.get(params, "query", ""),
      "status" => Map.get(params, "status", "")
    }

    {:noreply,
     assign(socket,
       table_page: params |> Map.get("page", "1") |> parse_page() |> max(1),
       table_filters: filters
     )}
  end

  def handle_params(_params, _uri, socket), do: {:noreply, socket}

  defp parse_page(page) do
    case Integer.parse(page) do
      {page, ""} -> page
      _ -> 1
    end
  end
end
