defmodule MatriarchUIDocsWeb.Docs.CommandPalettePageTest do
  use MatriarchUIDocsWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  test "renders in English and Russian", %{conn: conn} do
    assert {:ok, _view, english} = live(conn, ~p"/docs/components/command-palette")
    assert english =~ "Command Palette"
    assert english =~ "Search over anything"

    assert {:ok, _view, russian} = live(conn, ~p"/docs/components/command-palette?locale=ru")
    assert russian =~ "Палитра команд"
    assert russian =~ "Поиск по чему угодно"
  end

  test "the demo searches its own small dataset", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/docs/components/command-palette")

    html =
      view
      |> form("#demo-command-palette-form", search: %{query: "ada"})
      |> render_change()

    assert html =~ ~s(id="demo-command-palette-result-lovelace")
    assert html =~ "Lovelace"
    refute html =~ ~s(id="demo-command-palette-result-turing")
  end
end
