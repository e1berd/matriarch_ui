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

  test "min_size defaults to 0 so a panel can fully close" do
    html =
      render_component(&splitter/1, %{
        id: "layout",
        panel: [
          %{inner_block: fn _, _ -> "Left" end},
          %{inner_block: fn _, _ -> "Right" end}
        ]
      })

    assert html =~ ~s(data-mui-min-size="0")
  end

  test "min_size and max_size are passed through as panel data attributes" do
    html =
      render_component(&splitter/1, %{
        id: "layout",
        panel: [
          %{inner_block: fn _, _ -> "Left" end, min_size: 20, max_size: 60},
          %{inner_block: fn _, _ -> "Right" end}
        ]
      })

    assert html =~ ~s(data-mui-min-size="20")
    assert html =~ ~s(data-mui-max-size="60")
    assert html =~ ~s(data-mui-max-size="100")
  end

  test "storage_key is rendered as a data attribute when set" do
    html =
      render_component(&splitter/1, %{
        id: "layout",
        storage_key: "docs-layout",
        panel: [
          %{inner_block: fn _, _ -> "Left" end},
          %{inner_block: fn _, _ -> "Right" end}
        ]
      })

    assert html =~ ~s(data-mui-storage-key="docs-layout")
  end
end
