defmodule MatriarchUIDocsWeb.Docs.CommandPalettePageTest do
  use MatriarchUIDocsWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  test "renders in English and Russian", %{conn: conn} do
    assert {:ok, _view, english} = live(conn, ~p"/docs/components/command-palette")
    assert english =~ "Command Palette"
    assert english =~ "mode=&quot;search&quot;"
    assert english =~ "mode=&quot;raw&quot;"

    assert {:ok, _view, russian} = live(conn, ~p"/docs/components/command-palette?locale=ru")
    assert russian =~ "Палитра команд"
    assert russian =~ "mode=&quot;search&quot;"
    assert russian =~ "mode=&quot;raw&quot;"
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

  test "mode=\"raw\" renders the fixed tool list before anything is typed", %{conn: conn} do
    {:ok, view, html} = live(conn, ~p"/docs/components/command-palette")

    assert html =~ ~s(id="demo-command-palette-tools-result-new-file")
    assert html =~ ~s(id="demo-command-palette-tools-result-open-settings")
    assert html =~ ~s(data-mui-icon="file")
    assert html =~ ~s(data-mui-icon="gear")

    filtered =
      view
      |> form("#demo-command-palette-tools-form", search: %{query: "theme"})
      |> render_change()

    assert filtered =~ ~s(id="demo-command-palette-tools-result-toggle-theme")
    refute filtered =~ ~s(id="demo-command-palette-tools-result-new-file")
  end
end
