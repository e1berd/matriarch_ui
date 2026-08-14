defmodule MatriarchUIDocsWeb.SearchResultsPanel do
  @moduledoc """
  Owns the docs search state and adapts `MatriarchUIDocsWeb.Search`'s results
  into `MatriarchUI.CommandPalette`'s `:command` slot.

  Deliberately its own `LiveComponent`, nested inside `MatriarchUI.CommandPalette`'s
  dialog rather than rendered alongside it: this is the piece that re-renders
  on every keystroke, and isolating it keeps that from ever touching the
  dialog itself (see `MatriarchUI.CommandPalette`'s moduledoc for why that
  matters — the short version is that it resets the dialog's open state and
  steals focus back from the input otherwise).
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
      <.command_palette_search
        id={@palette_id}
        query={@query}
        event="search"
        target={@myself}
        locale={@locale}
      >
        <:command
          :for={result <- @results}
          id={result.slug}
          value={~p"/docs/components/#{result.slug}?#{locale_params(@locale)}"}
          title={result.title}
          subtitle={result.snippet}
        />
      </.command_palette_search>
    </div>
    """
  end

  def handle_event("search", %{"search" => %{"query" => query}}, socket) do
    results = Search.search(query, socket.assigns.locale)
    {:noreply, assign(socket, query: query, results: results)}
  end

  defp locale_params("ru"), do: [locale: "ru"]
  defp locale_params(_locale), do: []
end
