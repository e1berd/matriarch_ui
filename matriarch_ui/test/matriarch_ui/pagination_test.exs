defmodule MatriarchUI.PaginationTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest
  import MatriarchUI.Pagination

  defp query(html, selector),
    do: html |> LazyHTML.from_fragment() |> LazyHTML.query(selector) |> Enum.count()

  test "shows every page when total_pages is small" do
    html = render_component(&pagination/1, %{id: "pages", page: 2, total_pages: 4})

    assert query(html, ~s|button:not([aria-label])[phx-value-page="1"]|) == 1
    assert query(html, ~s|button:not([aria-label])[phx-value-page="4"]|) == 1
    assert query(html, ~s(button[aria-current="page"])) == 1
    refute html =~ "…"
  end

  test "collapses the middle into an ellipsis for large ranges" do
    html = render_component(&pagination/1, %{id: "pages", page: 10, total_pages: 30})

    assert html =~ "…"
    assert query(html, ~s|button:not([aria-label])[phx-value-page="1"]|) == 1
    assert query(html, ~s|button:not([aria-label])[phx-value-page="30"]|) == 1
    assert query(html, ~s(button[phx-value-page="10"][aria-current="page"])) == 1
  end

  test "prev button is disabled on the first page" do
    html = render_component(&pagination/1, %{id: "pages", page: 1, total_pages: 5})
    assert query(html, ~s(button[aria-label="Previous page"][disabled])) == 1
    assert query(html, ~s(button[aria-label="Next page"][disabled])) == 0
  end

  test "renders the translated table-style page-size area" do
    html =
      render_component(&pagination/1, %{
        id: "pages",
        page: 1,
        total_pages: 5,
        locale: "ru",
        page_size: [%{inner_block: fn _, _ -> "25" end}]
      })

    assert html =~ "Результатов на странице"
    assert query(html, ~s(nav[aria-label="Пагинация"])) == 1
    assert query(html, ~s(button[aria-label="Следующая страница"])) == 1
  end
end
