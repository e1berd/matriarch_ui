defmodule MatriarchUI.ScrollAreaTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest
  import MatriarchUI.ScrollArea

  defp query(html, selector),
    do: html |> LazyHTML.from_fragment() |> LazyHTML.query(selector) |> Enum.count()

  test "vertical renders a hidden native viewport and custom draggable scrollbar" do
    html =
      render_component(&scroll_area/1, %{
        id: "activity",
        inner_block: [%{inner_block: fn _, _ -> "Body" end}]
      })

    assert html =~ "Body"
    assert query(html, "#activity[phx-hook=\"MatriarchUI.ScrollArea.MUIScrollArea\"]") == 1
    assert query(html, "[data-mui-scroll-viewport].overflow-y-scroll.overflow-x-hidden") == 1
    assert query(html, "[data-mui-scrollbar=\"vertical\"] [data-mui-scroll-thumb]") == 1
    assert query(html, "[data-mui-scrollbar=\"horizontal\"]") == 0
  end

  test "orientation=both allows scrolling in either direction" do
    html =
      render_component(&scroll_area/1, %{
        orientation: "both",
        id: "canvas",
        inner_block: [%{inner_block: fn _, _ -> "Body" end}]
      })

    assert query(html, "[data-mui-scroll-viewport].overflow-scroll") == 1
    assert query(html, "[data-mui-scrollbar]") == 2
  end
end
