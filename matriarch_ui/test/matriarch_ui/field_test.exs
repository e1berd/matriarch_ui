defmodule MatriarchUI.FieldTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest
  import MatriarchUI.{Field, Fieldset}

  defp query(html, selector),
    do: html |> LazyHTML.from_fragment() |> LazyHTML.query(selector) |> Enum.count()

  test "the :let id passed to inner_block is the field's own id" do
    html =
      render_component(&field/1, %{
        id: "name",
        inner_block: [
          %{inner_block: fn _, id -> Phoenix.HTML.raw(~s(<input id="#{id}">)) end}
        ]
      })

    assert query(html, ~s(input#name)) == 1
  end

  test "field_label renders a <label for=...>" do
    html =
      render_component(&field_label/1, %{
        for: "name",
        inner_block: [%{inner_block: fn _, _ -> "Name" end}]
      })

    assert query(html, ~s(label[for="name"])) == 1
    assert html =~ "Name"
  end

  test "renders one paragraph per error" do
    html =
      render_component(&field/1, %{
        id: "email",
        errors: ["is invalid", "can't be blank"],
        inner_block: [%{inner_block: fn _, _ -> "" end}]
      })

    assert query(html, "p.text-mui-danger") == 2
  end

  test "orientation controls the field content direction" do
    horizontal =
      render_component(&field/1, %{
        id: "choice",
        orientation: "horizontal",
        inner_block: [%{inner_block: fn _, _ -> "Choice" end}]
      })

    vertical =
      render_component(&field/1, %{
        id: "name",
        inner_block: [%{inner_block: fn _, _ -> "Name" end}]
      })

    assert query(horizontal, ~s([data-mui-orientation="horizontal"])) == 1
    assert query(vertical, ~s([data-mui-orientation="vertical"])) == 1
  end

  test "fieldset renders a legend only when given" do
    with_legend =
      render_component(&fieldset/1, %{
        legend: [%{inner_block: fn _, _ -> "Contact details" end}],
        inner_block: [%{inner_block: fn _, _ -> "Body" end}]
      })

    without_legend =
      render_component(&fieldset/1, %{inner_block: [%{inner_block: fn _, _ -> "Body" end}]})

    assert with_legend =~ "Contact details"
    assert query(without_legend, "legend") == 0
  end
end
