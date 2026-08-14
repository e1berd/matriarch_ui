defmodule MatriarchUI.CommandPaletteTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest
  import MatriarchUI.CommandPalette

  defp query(html, selector),
    do: html |> LazyHTML.from_fragment() |> LazyHTML.query(selector) |> Enum.count()

  test "renders the trigger slot, targets its own dialog, and renders inner content" do
    html =
      render_component(&command_palette/1, %{
        id: "search",
        trigger: [%{inner_block: fn _, _ -> "test me" end}],
        inner_block: [%{inner_block: fn _, _ -> "search content" end}]
      })

    assert html =~ "test me"
    assert query(html, ~s(dialog#search-modal)) == 1
    assert html =~ "search content"
  end

  test "renders commands with automatic highlighting, an option id, and a maxlength" do
    html =
      render_component(&command_palette_search/1, %{
        id: "search",
        event: "search",
        query: "but",
        command: [
          %{
            id: "button",
            value: "/docs/components/button",
            title: "Button",
            subtitle: "a clickable control"
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

  test "renders an optional leading icon per command" do
    html =
      render_component(&command_palette_search/1, %{
        id: "search",
        event: "search",
        query: "but",
        command: [
          %{id: "button", value: "/docs/components/button", icon: "file", title: "Button"},
          %{id: "badge", value: "/docs/components/badge", title: "Badge"}
        ]
      })

    assert query(html, ~s(li#search-result-button [data-mui-icon="file"])) == 1
    assert query(html, ~s(li#search-result-badge [data-mui-icon])) == 0
  end

  test "does not highlight when the query isn't a literal substring" do
    html =
      render_component(&command_palette_search/1, %{
        id: "search",
        event: "search",
        query: "кнопка",
        command: [%{id: "button", value: "/docs/components/button", title: "Button"}]
      })

    assert html =~ "Button"
    assert query(html, ~s(mark)) == 0
  end

  test "max_length overrides the default input maxlength" do
    html =
      render_component(&command_palette_search/1, %{
        id: "search",
        event: "search",
        max_length: 40
      })

    assert query(html, ~s(input#search-input[maxlength="40"])) == 1
  end

  describe "mode: \"raw\" (the default)" do
    test "shows the not-found state with no query and no command" do
      html = render_component(&command_palette_search/1, %{id: "search", event: "search"})
      assert html =~ "Nothing found"
      refute html =~ "Search by name or on-page content"
    end

    test "renders every command before anything is typed" do
      html =
        render_component(&command_palette_search/1, %{
          id: "search",
          event: "search",
          command: [
            %{id: "button", value: "/docs/components/button", title: "Button"},
            %{id: "badge", value: "/docs/components/badge", title: "Badge"}
          ]
        })

      refute html =~ "Search by name or on-page content"
      assert query(html, ~s(li#search-result-button)) == 1
      assert query(html, ~s(li#search-result-badge)) == 1
    end
  end

  describe "mode: \"search\"" do
    test "shows the idle hint when the query is empty" do
      html =
        render_component(&command_palette_search/1, %{
          id: "search",
          event: "search",
          mode: "search"
        })

      assert html =~ "Search by name or on-page content"
      refute html =~ "Nothing found"
    end

    test "shows the not-found state for a query with no results" do
      html =
        render_component(&command_palette_search/1, %{
          id: "search",
          event: "search",
          mode: "search",
          query: "zzz"
        })

      assert html =~ "Nothing found"
      assert html =~ "Try a different search term"
    end

    test "an empty query always shows the idle hint, even if command is non-empty" do
      html =
        render_component(&command_palette_search/1, %{
          id: "search",
          event: "search",
          mode: "search",
          command: [%{id: "button", value: "/docs/components/button", title: "Button"}]
        })

      assert html =~ "Search by name or on-page content"
      assert query(html, ~s(li#search-result-button)) == 0
    end
  end

  test "binds the given event and target to the search form" do
    html =
      render_component(&command_palette_search/1, %{
        id: "search",
        event: "run-search",
        target: "42"
      })

    assert html =~ ~s(phx-change="run-search")
    assert html =~ ~s(phx-target="42")
  end
end
