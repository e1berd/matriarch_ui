defmodule MatriarchUI.SplitterTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest
  import MatriarchUI.Splitter

  defp query(html, selector),
    do: html |> LazyHTML.from_fragment() |> LazyHTML.query(selector) |> Enum.count()

  test "renders one panel per slot and a handle between each pair" do
    html =
      render_component(&splitter/1, %{
        id: "layout",
        panel: [
          %{inner_block: fn _, _ -> "Left" end},
          %{inner_block: fn _, _ -> "Middle" end},
          %{inner_block: fn _, _ -> "Right" end}
        ]
      })

    assert query(html, "[data-mui-panel]") == 3
    assert query(html, "[data-mui-handle]") == 2
    assert query(html, ~s([data-mui-handle] [data-mui-icon="dots-six-vertical"])) == 2
    assert html =~ "Left"
    assert html =~ "Right"
  end

  test "an explicit default_size is used as the initial flex-basis" do
    html =
      render_component(&splitter/1, %{
        id: "layout",
        panel: [
          %{inner_block: fn _, _ -> "Left" end, default_size: 30},
          %{inner_block: fn _, _ -> "Right" end}
        ]
      })

    assert html =~ "flex-basis: 30%"
  end
end
