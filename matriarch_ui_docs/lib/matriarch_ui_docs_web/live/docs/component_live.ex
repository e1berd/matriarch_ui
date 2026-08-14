defmodule MatriarchUIDocsWeb.Docs.ComponentLive do
  use MatriarchUIDocsWeb, :live_view
  alias MatriarchUI.I18n
  alias MatriarchUIDocsWeb.{DocsSidebar, ReaderPresence, Registry}
  import MatriarchUIDocsWeb.ReaderCount

  def mount(%{"slug" => slug} = params, _session, socket) do
    locale = I18n.normalize_locale(params["locale"])

    case Registry.fetch(slug, locale) do
      nil ->
        {:ok, push_navigate(socket, to: ~p"/docs")}

      entry ->
        {reader_topic, reader_count} = ReaderPresence.track(socket, "component:#{slug}")

        {:ok,
         assign(socket,
           page_title: entry.title,
           entry: entry,
           locale: locale,
           language_paths: language_paths(slug, params),
           pagination_page: 4,
           table_page: 1,
           table_filters: %{"query" => "", "status" => ""},
           reader_topic: reader_topic,
           reader_count: reader_count
         )}
    end
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} locale={@locale} language_paths={@language_paths}>
      <div class="mx-auto flex max-w-6xl gap-2 px-6">
        <DocsSidebar.sidebar active={@entry.slug} locale={@locale} />
        <div class="min-w-0 flex-1 border-l border-mui-border py-8 pl-7">
          <h1 class="text-2xl font-semibold tracking-tight text-mui-foreground">{@entry.title}</h1>
          <.reader_count count={@reader_count} locale={@locale} class="mt-1.5" />
          <div class="mt-6 flex flex-col gap-8">
            {apply(@entry.module, :examples, [
              %{
                page: @pagination_page,
                table_page: @table_page,
                filters: @table_filters,
                locale: @locale
              }
            ])}
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end

  def handle_event("paginate", %{"page" => page}, socket) do
    page = page |> parse_page() |> max(1) |> min(12)
    params = with_locale([page: page], socket.assigns.locale)
    {:noreply, push_patch(socket, to: ~p"/docs/components/pagination?#{params}")}
  end

  def handle_event("resume-selected", %{"files" => _files}, socket), do: {:noreply, socket}

  def handle_event("filter-table", %{"filters" => filters}, socket) do
    params = [
      query: Map.get(filters, "query", ""),
      status: Map.get(filters, "status", ""),
      page: 1
    ]

    params = with_locale(params, socket.assigns.locale)
    {:noreply, push_patch(socket, to: ~p"/docs/components/table?#{params}")}
  end

  def handle_event("paginate-table", %{"page" => page}, socket) do
    filters = socket.assigns.table_filters

    params = [
      query: Map.get(filters, "query", ""),
      status: Map.get(filters, "status", ""),
      page: max(parse_page(page), 1)
    ]

    params = with_locale(params, socket.assigns.locale)
    {:noreply, push_patch(socket, to: ~p"/docs/components/table?#{params}")}
  end

  def handle_info(message, socket) do
    if ReaderPresence.diff?(socket.assigns.reader_topic, message) do
      {:noreply, assign(socket, reader_count: ReaderPresence.count(socket.assigns.reader_topic))}
    else
      {:noreply, socket}
    end
  end

  def handle_params(params, _uri, socket) do
    locale = I18n.normalize_locale(params["locale"])
    entry = Registry.fetch(socket.assigns.entry.slug, locale)

    socket =
      assign(socket,
        page_title: entry.title,
        entry: entry,
        locale: locale,
        language_paths: language_paths(socket.assigns.entry.slug, params)
      )

    socket =
      case socket.assigns.entry.slug do
        "pagination" ->
          page = params |> Map.get("page", "4") |> parse_page() |> max(1) |> min(12)
          assign(socket, :pagination_page, page)

        "table" ->
          filters = %{
            "query" => Map.get(params, "query", ""),
            "status" => Map.get(params, "status", "")
          }

          assign(socket,
            table_page: params |> Map.get("page", "1") |> parse_page() |> max(1),
            table_filters: filters
          )

        _slug ->
          socket
      end

    {:noreply, socket}
  end

  defp parse_page(page) do
    case Integer.parse(page) do
      {page, ""} -> page
      _ -> 1
    end
  end

  defp with_locale(params, "ru"), do: params ++ [locale: "ru"]
  defp with_locale(params, _locale), do: params

  defp language_paths(slug, params) do
    params = Map.drop(params, ["slug", "locale"])

    %{
      "en" => ~p"/docs/components/#{slug}?#{params}",
      "ru" => ~p"/docs/components/#{slug}?#{Map.put(params, "locale", "ru")}"
    }
  end
end
