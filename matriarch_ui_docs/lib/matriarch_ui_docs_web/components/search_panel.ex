defmodule MatriarchUIDocsWeb.SearchPanel do
  @moduledoc """
  Owns the docs search state and adapts `MatriarchUIDocsWeb.Search`'s results
  into `MatriarchUI.CommandPalette`'s generic `%{id:, url:, title:, description:}`
  shape — the trigger, dialog, keyboard navigation and highlighting all come
  from the shared library component.
  """
  use Phoenix.LiveComponent

  use Phoenix.VerifiedRoutes,
    endpoint: MatriarchUIDocsWeb.Endpoint,
    router: MatriarchUIDocsWeb.Router

  use MatriarchUI
  alias MatriarchUIDocsWeb.Search

  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_new(:query, fn -> "" end)
      |> assign_new(:results, fn -> [] end)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div id={@id}>
      <.command_palette_trigger id={"#{@id}-palette"} locale={@locale} />
      <.command_palette
        id={"#{@id}-palette"}
        query={@query}
        results={@results}
        event="search"
        target={@myself}
        locale={@locale}
      />
    </div>
    """
  end

  def handle_event("search", %{"search" => %{"query" => query}}, socket) do
    locale = socket.assigns.locale
    results = query |> Search.search(locale) |> Enum.map(&to_result(&1, locale))

    {:noreply, assign(socket, query: query, results: results)}
  end

  defp to_result(match, locale) do
    %{
      id: match.slug,
      url: ~p"/docs/components/#{match.slug}?#{locale_params(locale)}",
      title: match.title_segments,
      description: match.snippet_segments
    }
  end

  defp locale_params("ru"), do: [locale: "ru"]
  defp locale_params(_locale), do: []
end
