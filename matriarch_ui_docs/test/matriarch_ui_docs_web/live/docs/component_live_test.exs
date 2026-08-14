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

  test "Russian locale translates component documentation", %{conn: conn} do
    {:ok, _view, html} = live(conn, ~p"/docs/components/autocomplete?locale=ru")

    assert html =~ "Автодополнение"
    assert html =~ "Основной пример"
    assert html =~ "Список открывается при фокусе"
    assert html =~ "Описание"
    assert html =~ "связывает name/value/invalid с формой"
  end

  test "every component has an English and Russian title", %{conn: conn} do
    english = MatriarchUIDocsWeb.Registry.components("en")
    russian = MatriarchUIDocsWeb.Registry.components("ru")

    assert Enum.map(english, & &1.slug) == Enum.map(russian, & &1.slug)
    assert Enum.all?(english, &(&1.title != ""))
    assert Enum.all?(russian, &(&1.title != ""))
    assert Enum.zip_with(english, russian, fn en, ru -> en.title != ru.title end) |> Enum.all?()

    Enum.each(russian, fn component ->
      assert {:ok, _view, html} = live(conn, "/docs/components/#{component.slug}?locale=ru")
      assert html =~ component.title
    end)
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
