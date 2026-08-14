defmodule MatriarchUI.SliderTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest
  import MatriarchUI.Slider

  defp query(html, selector),
    do: html |> LazyHTML.from_fragment() |> LazyHTML.query(selector) |> Enum.count()

  test "renders a range input with the given name/value/min/max" do
    html =
      render_component(&slider/1, %{name: "volume", id: "volume", value: 30, min: 0, max: 50})

    assert query(html, ~s(input[type="range"][name="volume"][value="30"][min="0"][max="50"])) == 1
  end

  test "sets the --mui-slider-fill custom property from value/min/max" do
    html = render_component(&slider/1, %{name: "v", value: 25, min: 0, max: 100})
    assert html =~ "--mui-slider-fill: 25.0%"
  end

  test "falls back to the min when value is out of range parsing" do
    html = render_component(&slider/1, %{name: "v", value: nil, min: 10, max: 20})
    assert html =~ "--mui-slider-fill: 0.0%"
  end
end
