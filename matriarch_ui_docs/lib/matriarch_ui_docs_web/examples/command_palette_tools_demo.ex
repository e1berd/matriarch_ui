defmodule MatriarchUIDocsWeb.Examples.CommandPaletteToolsDemo do
  @moduledoc """
  Search state for the `mode="raw"` demo on the `MatriarchUI.CommandPalette`
  doc page — a fixed list of tools/actions, all visible before the reader
  types anything, filtered as they do. Isolated in its own `LiveComponent`
  for the same reason `MatriarchUIDocsWeb.Examples.CommandPaletteDemo` is.
  """
  use Phoenix.LiveComponent
  use MatriarchUI

  @actions [
    %{id: "new-file", name: "New file", hint: "Create an empty file", icon: "file"},
    %{id: "open-settings", name: "Open settings", hint: "Edit your preferences", icon: "gear"},
    %{
      id: "toggle-theme",
      name: "Toggle theme",
      hint: "Switch between light and dark",
      icon: "moon"
    },
    %{id: "sign-out", name: "Sign out", hint: "End your session", icon: "sign-out"}
  ]

  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_new(:query, fn -> "" end)
      |> assign_new(:results, fn -> @actions end)

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
        mode="raw"
      >
        <:command
          :for={result <- @results}
          id={result.id}
          value="/docs/components/command-palette"
          icon={result.icon}
          title={result.name}
          subtitle={result.hint}
        />
      </.command_palette_search>
    </div>
    """
  end

  def handle_event("search", %{"search" => %{"query" => query}}, socket) do
    {:noreply, assign(socket, query: query, results: search(query))}
  end

  defp search(""), do: @actions

  defp search(query) do
    Enum.filter(@actions, &String.contains?(String.downcase(&1.name), String.downcase(query)))
  end
end
