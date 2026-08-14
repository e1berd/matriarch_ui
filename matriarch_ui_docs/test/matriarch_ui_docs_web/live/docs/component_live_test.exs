defmodule MatriarchUIDocsWeb.Docs.ComponentLiveTest do
  use MatriarchUIDocsWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  @new_components ~w(
    color-input date-input date-picker email-input file-upload list number-input password-input phone-input progressbar radio spinner
  )

  test "new component pages render live examples", %{conn: conn} do
    Enum.each(@new_components, fn slug ->
      assert {:ok, _view, html} = live(conn, "/docs/components/#{slug}")
      assert html =~ "data-mui"
    end)
  end

  test "Russian locale translates UI kit labels and stays in pagination patches", %{conn: conn} do
    {:ok, view, html} = live(conn, ~p"/docs/components/pagination?locale=ru")

    assert html =~ "Результатов на странице"
    assert html =~ "Русский"

    view |> element("#results-pagination-next") |> render_click()
    assert_patch(view, ~p"/docs/components/pagination?#{[page: 5, locale: "ru"]}")
  end

  test "pagination writes the selected page to the query string", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/docs/components/pagination")

    view |> element("#results-pagination-next") |> render_click()

    assert_patch(view, ~p"/docs/components/pagination?#{[page: 5]}")
    assert has_element?(view, ~s(#results-pagination-page[value="5"]))
  end

  test "pagination restores its state from query parameters", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/docs/components/pagination?#{[page: 8]}")
    assert has_element?(view, ~s(#results-pagination-page[value="8"]))
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
