defmodule MatriarchUI.CommandPaletteTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest
  import MatriarchUI.CommandPalette

  defp query(html, selector),
    do: html |> LazyHTML.from_fragment() |> LazyHTML.query(selector) |> Enum.count()

  test "trigger shows the shortcut hint and targets the paired dialog" do
    html = render_component(&command_palette_trigger/1, %{id: "search"})
    assert html =~ "⌘K"
    assert html =~ "#search-modal"
  end

  test "shows the idle hint when the query is empty" do
    html = render_component(&command_palette/1, %{id: "search", event: "search"})
    assert html =~ "Search by name or on-page content"
    refute html =~ "Nothing found"
  end

  test "shows the not-found state for a query with no results" do
    html = render_component(&command_palette/1, %{id: "search", event: "search", query: "zzz"})
    assert html =~ "Nothing found"
    assert html =~ "Try a different search term"
  end

  test "renders results with highlighted segments, an option id, and a maxlength" do
    html =
      render_component(&command_palette/1, %{
        id: "search",
        event: "search",
        query: "but",
        results: [
          %{
            id: "button",
            url: "/docs/components/button",
            title: [{:mark, "But"}, {:text, "ton"}],
            description: "a clickable control"
          }
        ]
      })

    assert query(html, ~s(a#search-option-button[role="option"][aria-selected="false"])) == 1
    assert query(html, ~s(li#search-result-button)) == 1
    assert query(html, ~s(mark)) == 1
    assert html =~ "But"
    assert html =~ "a clickable control"
    assert query(html, ~s(input#search-input[maxlength="80"])) == 1
  end

  test "max_length overrides the default input maxlength" do
    html =
      render_component(&command_palette/1, %{id: "search", event: "search", max_length: 40})

    assert query(html, ~s(input#search-input[maxlength="40"])) == 1
  end

  test "renders a plain string title without a <mark>" do
    html =
      render_component(&command_palette/1, %{
        id: "search",
        event: "search",
        query: "but",
        results: [%{id: "button", url: "/docs/components/button", title: "Button"}]
      })

    assert html =~ "Button"
    assert query(html, ~s(mark)) == 0
  end

  test "binds the given event and target to the search form" do
    html =
      render_component(&command_palette/1, %{
        id: "search",
        event: "run-search",
        target: "42"
      })

    assert html =~ ~s(phx-change="run-search")
    assert html =~ ~s(phx-target="42")
  end
end
