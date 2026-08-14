defmodule MatriarchUIDocsWeb.Docs.ComponentLiveTest do
  use MatriarchUIDocsWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  test "pagination writes the selected page to the query string", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/docs/components/pagination")

    view |> element("#results-pagination-next") |> render_click()

    assert_patch(view, ~p"/docs/components/pagination?#{[page: 5]}")
    assert has_element?(view, ~s(#results-pagination-page-5[aria-current="page"]))
  end

  test "pagination restores its state from query parameters", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/docs/components/pagination?#{[page: 8]}")
    assert has_element?(view, ~s(#results-pagination-page-8[aria-current="page"]))
  end

  test "table filters update query parameters and visible rows", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/docs/components/table")

    view
    |> form("#users-filters", filters: %{query: "Olivia"})
    |> render_change()

    assert_patch(
      view,
      ~p"/docs/components/table?#{[query: "Olivia", status: "", page: 1]}"
    )

    assert render(view) =~ "Olivia Martin"
    refute render(view) =~ "Cameron Walker"
  end
end
