defmodule MatriarchUI.PaginationTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest
  import MatriarchUI.Pagination

  defp query(html, selector),
    do: html |> LazyHTML.from_fragment() |> LazyHTML.query(selector) |> Enum.count()

  test "renders only arrows, editable current page, and total pages" do
    html = render_component(&pagination/1, %{id: "pages", page: 2, total_pages: 12})

    assert query(html, ~s(button#pages-previous[phx-value-page="1"])) == 1
    assert query(html, ~s(button#pages-next[phx-value-page="3"])) == 1
    assert query(html, ~s(input#pages-page[name="page"][value="2"][min="1"][max="12"])) == 1
    assert html =~ "of 12"
    assert query(html, ~s(button[id^="pages-page-"])) == 0
  end

  test "clamps server-rendered page state to the available range" do
    html = render_component(&pagination/1, %{id: "pages", page: 99, total_pages: 12})

    assert query(html, ~s(input#pages-page[value="12"])) == 1
    assert query(html, ~s(button#pages-next[disabled])) == 1
  end

  test "previous button is disabled on the first page" do
    html = render_component(&pagination/1, %{id: "pages", page: 1, total_pages: 5})
    assert query(html, ~s(button[aria-label="Previous page"][disabled])) == 1
    assert query(html, ~s(button[aria-label="Next page"][disabled])) == 0
  end

  test "renders the translated page-size area and page input label" do
    html =
      render_component(&pagination/1, %{
        id: "pages",
        page: 1,
        total_pages: 5,
        locale: "ru",
        page_size: [%{inner_block: fn _, _ -> "25" end}]
      })

    assert html =~ "Результатов на странице"
    assert html =~ "из 5"
    assert query(html, ~s(nav[aria-label="Пагинация"])) == 1
    assert query(html, ~s(input[aria-label="Текущая страница"])) == 1
  end
end
