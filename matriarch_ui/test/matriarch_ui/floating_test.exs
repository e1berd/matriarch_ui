defmodule MatriarchUI.FloatingTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest
  import MatriarchUI.{Tooltip, Popover, DropdownMenu}

  defp query(html, selector),
    do: html |> LazyHTML.from_fragment() |> LazyHTML.query(selector) |> Enum.count()

  test "tooltip trigger and panel are linked via aria-controls" do
    html =
      render_component(&tooltip/1, %{
        id: "info",
        text: "More info",
        inner_block: [%{inner_block: fn _, _ -> "?" end}]
      })

    doc = LazyHTML.from_fragment(html)
    [trigger] = LazyHTML.query(doc, "#info-trigger") |> Enum.to_list()
    assert LazyHTML.attribute(trigger, "aria-controls") == ["info-panel"]
    assert query(html, "#info-panel[role=\"tooltip\"]") == 1
    assert html =~ "More info"
  end

  test "popover renders a trigger and a dialog panel" do
    html =
      render_component(&popover/1, %{
        id: "settings",
        trigger: [%{inner_block: fn _, _ -> "Open" end}],
        inner_block: [%{inner_block: fn _, _ -> "Panel content" end}]
      })

    assert query(html, ~s(div#settings-trigger[aria-controls="settings-panel"])) == 1
    assert query(html, ~s(div#settings-panel[role="dialog"])) == 1
    assert html =~ "Panel content"
  end

  test "popover trigger wraps a nested <button> without invalid button-in-button markup" do
    html =
      render_component(&popover/1, %{
        id: "share",
        trigger: [
          %{
            inner_block: fn _, _ -> Phoenix.HTML.raw(~s(<button type="button">Share</button>)) end
          }
        ],
        inner_block: [%{inner_block: fn _, _ -> "content" end}]
      })

    assert query(html, ~s(div#share-trigger button)) == 1
    assert query(html, "button button") == 0
  end

  test "dropdown_menu renders one menuitem link per item slot" do
    html =
      render_component(&dropdown_menu/1, %{
        id: "actions",
        trigger: [%{inner_block: fn _, _ -> "Actions" end}],
        item: [
          %{inner_block: fn _, _ -> "Edit" end},
          %{inner_block: fn _, _ -> "Delete" end, variant: "danger"}
        ]
      })

    assert query(html, ~s(div#actions-panel[role="menu"])) == 1
    assert query(html, ~s([role="menuitem"])) == 2
    assert html =~ "Edit"
    assert html =~ "Delete"
  end
end
