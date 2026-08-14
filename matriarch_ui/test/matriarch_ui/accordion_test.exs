defmodule MatriarchUI.AccordionTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest
  import MatriarchUI.Accordion

  defp query(html, selector),
    do: html |> LazyHTML.from_fragment() |> LazyHTML.query(selector) |> Enum.count()

  test "renders one trigger/panel pair per item, open only for values in :default" do
    html =
      render_component(&accordion/1, %{
        id: "faq",
        default: ["q1"],
        item: [
          %{inner_block: fn _, _ -> "Answer one" end, value: "q1", title: "Question one"},
          %{inner_block: fn _, _ -> "Answer two" end, value: "q2", title: "Question two"}
        ]
      })

    assert query(html, ~s(button[aria-expanded="true"])) == 1
    assert query(html, ~s(button[aria-expanded="false"])) == 1
    assert query(html, ~s(#faq-q1-panel[data-mui-state="open"])) == 1
    assert query(html, ~s(#faq-q2-panel[data-mui-state="closed"])) == 1
    assert html =~ "Question one"
    assert html =~ "Answer two"
  end

  test "defaults to type=single and no item open" do
    html =
      render_component(&accordion/1, %{
        id: "faq",
        item: [%{inner_block: fn _, _ -> "Answer" end, value: "q1", title: "Question"}]
      })

    assert query(html, ~s(#faq[data-mui-type="single"])) == 1
    assert query(html, ~s(button[aria-expanded="false"])) == 1
  end
end
