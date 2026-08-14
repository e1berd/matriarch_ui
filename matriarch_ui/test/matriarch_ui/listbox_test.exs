defmodule MatriarchUI.ListboxTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest
  import MatriarchUI.Listbox

  defp query(html, selector),
    do: html |> LazyHTML.from_fragment() |> LazyHTML.query(selector) |> Enum.count()

  test "single-select renders radios and checks the matching value" do
    html =
      render_component(&listbox/1, %{
        id: "fruit",
        name: "fruit",
        value: "apple",
        option: [
          %{value: "apple", inner_block: fn _, _ -> "Apple" end},
          %{value: "banana", inner_block: fn _, _ -> "Banana" end}
        ]
      })

    assert query(html, ~s(input[type="radio"])) == 2
    assert query(html, ~s(input[type="radio"][value="apple"][checked])) == 1
    assert query(html, ~s([role="option"][aria-selected="true"])) == 1
  end

  test "multiple=true renders checkboxes and checks every value in the list" do
    html =
      render_component(&listbox/1, %{
        id: "fruit",
        name: "fruit[]",
        value: ["apple", "banana"],
        multiple: true,
        option: [
          %{value: "apple", inner_block: fn _, _ -> "Apple" end},
          %{value: "banana", inner_block: fn _, _ -> "Banana" end},
          %{value: "cherry", inner_block: fn _, _ -> "Cherry" end}
        ]
      })

    assert query(html, ~s(input[type="checkbox"])) == 3
    assert query(html, ~s(input[type="checkbox"][checked])) == 2
    assert query(html, ~s(div[role="listbox"][aria-multiselectable="true"])) == 1
  end
end
