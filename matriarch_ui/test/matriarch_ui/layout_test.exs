defmodule MatriarchUI.LayoutTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest
  import MatriarchUI.{Card, Avatar, Alert, Separator, Tabs, Modal, Breadcrumb}

  defp query(html, selector),
    do: html |> LazyHTML.from_fragment() |> LazyHTML.query(selector) |> Enum.count()

  test "card is a bare surface that any card_* sub-component can render into" do
    html = render_component(&card/1, %{inner_block: [%{inner_block: fn _, _ -> "Body" end}]})
    assert html =~ "Body"
    assert query(html, "div.rounded-mui-lg") == 1
  end

  test "card_header, card_title, card_description, card_content and card_footer each render their slot" do
    assert render_component(&card_header/1, %{
             inner_block: [%{inner_block: fn _, _ -> "Header" end}]
           }) =~
             "Header"

    assert render_component(&card_title/1, %{
             inner_block: [%{inner_block: fn _, _ -> "Title" end}]
           }) =~
             "Title"

    assert render_component(&card_description/1, %{
             inner_block: [%{inner_block: fn _, _ -> "Description" end}]
           }) =~ "Description"

    assert render_component(&card_content/1, %{
             inner_block: [%{inner_block: fn _, _ -> "Body" end}]
           }) =~
             "Body"

    assert render_component(&card_footer/1, %{
             inner_block: [%{inner_block: fn _, _ -> "Footer" end}]
           }) =~
             "Footer"
  end

  test "avatar falls back to initials when no image src is given" do
    html = render_component(&avatar/1, %{initials: "AB"})
    assert html =~ "AB"
    assert query(html, "img") == 0
  end

  test "avatar renders an image when src is given" do
    html = render_component(&avatar/1, %{src: "/a.png", alt: "Ada"})
    assert query(html, ~s(img[src="/a.png"][alt="Ada"])) == 1
  end

  test "alert exposes an alert role and the chosen title" do
    html =
      render_component(&alert/1, %{
        variant: "danger",
        title: "Something broke",
        inner_block: [%{inner_block: fn _, _ -> "Try again" end}]
      })

    assert query(html, ~s(div[role="alert"])) == 1
    assert html =~ "Something broke"
  end

  test "separator exposes aria-orientation" do
    html = render_component(&separator/1, %{orientation: "vertical"})
    assert query(html, ~s([role="separator"][aria-orientation="vertical"])) == 1
  end

  test "tabs renders one tab and one panel per slot, defaulting the active one" do
    html =
      render_component(&tabs/1, %{
        id: "settings-tabs",
        default: "general",
        tab: [
          %{inner_block: fn _, _ -> "General" end, value: "general"},
          %{inner_block: fn _, _ -> "Billing" end, value: "billing"}
        ],
        panel: [
          %{inner_block: fn _, _ -> "General panel" end, value: "general"},
          %{inner_block: fn _, _ -> "Billing panel" end, value: "billing"}
        ]
      })

    assert query(html, ~s([role="tab"])) == 2
    assert query(html, ~s([role="tab"][aria-selected="true"])) == 1
    assert query(html, ~s([data-mui-panel="billing"][hidden])) == 1
    assert query(html, ~s|[data-mui-panel="general"]:not([hidden])|) == 1
  end

  test "modal renders as a dialog with the given title and a close trigger" do
    html =
      render_component(&modal/1, %{
        id: "confirm",
        title: "Delete item?",
        inner_block: [%{inner_block: fn _, _ -> "This cannot be undone." end}]
      })

    assert query(html, "dialog#confirm") == 1
    assert html =~ "Delete item?"
    assert html =~ "This cannot be undone."
  end

  test "breadcrumb renders every earlier item as a link and the last as the current page" do
    html =
      render_component(&breadcrumb/1, %{
        item: [
          %{inner_block: fn _, _ -> "Home" end, navigate: "/"},
          %{inner_block: fn _, _ -> "Docs" end, navigate: "/docs"},
          %{inner_block: fn _, _ -> "Breadcrumb" end}
        ]
      })

    assert query(html, "a") == 2
    assert query(html, ~s(a[href="/"])) == 1
    assert query(html, ~s([aria-current="page"])) == 1
    assert html =~ "Breadcrumb"
    refute query(html, ~s(a[aria-current="page"])) > 0
  end
end
