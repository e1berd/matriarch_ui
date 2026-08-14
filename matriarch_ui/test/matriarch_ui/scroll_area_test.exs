defmodule MatriarchUI.ScrollAreaTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest
  import MatriarchUI.ScrollArea

  defp query(html, selector),
    do: html |> LazyHTML.from_fragment() |> LazyHTML.query(selector) |> Enum.count()

  test "vertical (default) scrolls y and clips x" do
    html =
      render_component(&scroll_area/1, %{inner_block: [%{inner_block: fn _, _ -> "Body" end}]})

    assert html =~ "Body"
    assert query(html, "div.overflow-y-auto.overflow-x-hidden") == 1
  end

  test "orientation=both allows scrolling in either direction" do
    html =
      render_component(&scroll_area/1, %{
        orientation: "both",
        inner_block: [%{inner_block: fn _, _ -> "Body" end}]
      })

    assert query(html, "div.overflow-auto") == 1
  end
end
