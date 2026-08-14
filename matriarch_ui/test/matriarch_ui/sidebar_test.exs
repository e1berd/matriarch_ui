defmodule MatriarchUI.SidebarTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest
  import MatriarchUI.Sidebar

  defp query(html, selector),
    do: html |> LazyHTML.from_fragment() |> LazyHTML.query(selector) |> Enum.count()

  test "renders the root open by default and a backdrop for the mobile drawer" do
    html =
      render_component(&sidebar/1, %{
        id: "app-sidebar",
        inner_block: [%{inner_block: fn _, _ -> "Nav" end}]
      })

    assert query(html, ~s(#app-sidebar[data-mui-state="open"])) == 1
    assert query(html, ~s([data-mui-backdrop][data-mui-state="closed"])) == 1
    assert html =~ "Nav"
  end

  test "sidebar_trigger dispatches mui:toggle-sidebar at the given sidebar id" do
    html = render_component(&sidebar_trigger/1, %{for: "app-sidebar"})
    assert html =~ "mui:toggle-sidebar"
    assert query(html, ~s(button[aria-controls="app-sidebar"])) == 1
  end

  test "sidebar_menu_item renders as a link and marks the active item" do
    html =
      render_component(&sidebar_menu_item/1, %{
        navigate: "/dashboard",
        active: true,
        inner_block: [%{inner_block: fn _, _ -> "Dashboard" end}]
      })

    assert query(html, ~s(a[href="/dashboard"])) == 1
    assert html =~ "Dashboard"
    assert html =~ "bg-mui-primary-subtle"
  end

  test "sidebar_group shows its label only when given" do
    with_label =
      render_component(&sidebar_group/1, %{
        label: "Workspace",
        inner_block: [%{inner_block: fn _, _ -> "Body" end}]
      })

    without_label =
      render_component(&sidebar_group/1, %{inner_block: [%{inner_block: fn _, _ -> "Body" end}]})

    assert with_label =~ "Workspace"
    assert query(without_label, "p") == 0
  end
end
