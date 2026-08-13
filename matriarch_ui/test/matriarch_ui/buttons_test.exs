defmodule MatriarchUI.ButtonsTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest
  import MatriarchUI.Button
  import MatriarchUI.Badge

  test "button renders as a button with the given type and default variant" do
    html =
      render_component(&button/1, %{
        type: "submit",
        inner_block: [%{inner_block: fn _, _ -> "Save" end}]
      })

    doc = LazyHTML.from_fragment(html)
    assert doc |> LazyHTML.query(~s(button[type="submit"])) |> Enum.count() == 1
    assert html =~ "Save"
  end

  test "button loading state disables the element and shows a spinner" do
    html =
      render_component(&button/1, %{
        loading: true,
        inner_block: [%{inner_block: fn _, _ -> "Save" end}]
      })

    doc = LazyHTML.from_fragment(html)
    assert doc |> LazyHTML.query("button[disabled]") |> Enum.count() == 1
    assert html =~ "animate-spin"
  end

  test "badge renders the requested variant content" do
    html = render_component(&badge/1, %{inner_block: [%{inner_block: fn _, _ -> "New" end}]})
    assert html =~ "New"
    doc = LazyHTML.from_fragment(html)
    assert doc |> LazyHTML.query("span") |> Enum.count() == 1
  end
end
