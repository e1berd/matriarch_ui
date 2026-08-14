defmodule MatriarchUIDocsWeb.SearchPanelTest do
  use MatriarchUIDocsWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  @form "#docs-search-palette-form"

  test "typing a query renders matching component results", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/docs/components/badge")

    html = view |> form(@form, search: %{query: "button"}) |> render_change()

    assert html =~ "Button"
  end

  test "tolerates a query typed on the wrong keyboard layout", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/docs/components/badge")

    html = view |> form(@form, search: %{query: "игеещт"}) |> render_change()

    assert html =~ "Button"
  end

  test "shows an empty state for no matches", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/docs/components/badge")

    html = view |> form(@form, search: %{query: "zzzznonexistentzzzz"}) |> render_change()

    assert html =~ "Nothing found"
  end

  test "shows an idle hint before anything is typed", %{conn: conn} do
    {:ok, _view, html} = live(conn, ~p"/docs/components/badge")

    assert html =~ "Search by name or on-page content"
  end
end
