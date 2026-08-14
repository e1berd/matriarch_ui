defmodule MatriarchUIDocsWeb.Examples.CommandPaletteDemo do
  @moduledoc """
  Search state for the `MatriarchUI.CommandPalette` doc-page demo, isolated
  in its own `LiveComponent` for the same reason `MatriarchUIDocsWeb.SearchResultsPanel`
  is: so typing doesn't re-render (and reset) the dialog around it.
  """
  use Phoenix.LiveComponent
  use MatriarchUI

  @scientists [
    %{id: "lovelace", name: "Ada Lovelace", role: "Wrote the first published algorithm"},
    %{id: "turing", name: "Alan Turing", role: "Formalized computation and computability"},
    %{id: "hopper", name: "Grace Hopper", role: "Built the first compiler"},
    %{id: "hamilton", name: "Margaret Hamilton", role: "Led the Apollo flight software team"},
    %{id: "lamport", name: "Leslie Lamport", role: "Formalized distributed systems, and LaTeX"},
    %{id: "liskov", name: "Barbara Liskov", role: "Pioneered data abstraction and substitution"}
  ]

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
          id={result.id}
          value="/docs/components/command-palette"
          title={result.name}
          subtitle={result.role}
        />
      </.command_palette_search>
    </div>
    """
  end

  def handle_event("search", %{"search" => %{"query" => query}}, socket) do
    {:noreply, assign(socket, query: query, results: search(query))}
  end

  defp search(query) do
    query = String.trim(query)

    if query == "" do
      []
    else
      Enum.filter(
        @scientists,
        &String.contains?(String.downcase(&1.name), String.downcase(query))
      )
    end
  end
end
