defmodule MatriarchUI.CarouselTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest
  import MatriarchUI.Carousel

  defp query(html, selector),
    do: html |> LazyHTML.from_fragment() |> LazyHTML.query(selector) |> Enum.count()

  test "renders one tracked slide and one dot per slide slot, plus prev/next buttons" do
    html =
      render_component(&carousel/1, %{
        id: "gallery",
        slide: [
          %{inner_block: fn _, _ -> "Slide one" end},
          %{inner_block: fn _, _ -> "Slide two" end}
        ]
      })

    assert query(html, "[data-mui-slide]") == 2
    assert query(html, "[data-mui-dot]") == 2
    assert query(html, "[data-mui-prev]") == 1
    assert query(html, "[data-mui-next]") == 1
    assert html =~ "Slide one"
    assert html =~ "Slide two"
  end
end
