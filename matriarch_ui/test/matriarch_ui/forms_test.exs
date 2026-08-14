defmodule MatriarchUI.FormsTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest
  import MatriarchUI.{Input, Textarea, Checkbox, Switch, RadioGroup, Select}

  defp count(html, selector),
    do: html |> LazyHTML.from_fragment() |> LazyHTML.query(selector) |> Enum.count()

  test "input renders label, name and value from plain assigns" do
    html =
      render_component(&input/1, %{
        name: "user_email",
        id: "email",
        value: "a@b.com",
        label: "Email"
      })

    assert count(html, ~s(input[name="user_email"][value="a@b.com"])) == 1
    assert html =~ "Email"
  end

  test "input surfaces errors and applies the danger border" do
    html = render_component(&input/1, %{name: "email", id: "email", errors: ["is invalid"]})
    assert html =~ "is invalid"
    assert count(html, "input.border-mui-danger") == 1
  end

  test "textarea renders the given value as its content" do
    html = render_component(&textarea/1, %{name: "bio", id: "bio", value: "hello world"})
    assert html =~ "hello world"
    assert count(html, "textarea#bio") == 1
  end

  test "checkbox marks the input checked and keeps a hidden fallback field" do
    html =
      render_component(&checkbox/1, %{name: "tos", id: "tos", checked: true, label: "Accept"})

    assert count(html, ~s(input[type="hidden"][name="tos"][value="false"])) == 1
    assert count(html, ~s(input[type="checkbox"][checked])) == 1
  end

  test "switch renders a checkbox input styled as a track/thumb" do
    html = render_component(&switch/1, %{name: "notify", id: "notify", checked: false})
    assert count(html, ~s(input[type="checkbox"]#notify)) == 1
  end

  test "radio_group renders one radio per option and checks the matching value" do
    html =
      render_component(&radio_group/1, %{
        id: "plan",
        name: "plan",
        value: "pro",
        options: [{"Free", "free"}, {"Pro", "pro"}]
      })

    assert count(html, ~s(input[type="radio"])) == 2
    assert count(html, ~s(input[type="radio"][value="pro"][checked])) == 1
  end

  test "select renders the trigger, hidden value input and one option per slot entry" do
    html =
      render_component(&select/1, %{
        id: "role",
        name: "role",
        value: "admin",
        option: [
          %{value: "admin", inner_block: fn _, _ -> "Admin" end},
          %{value: "viewer", inner_block: fn _, _ -> "Viewer" end}
        ]
      })

    assert count(html, ~s(input[type="hidden"][name="role"][value="admin"])) == 1
    assert count(html, ~s([role="option"])) == 2
    assert count(html, ~s([role="option"][data-mui-value="admin"][aria-selected="true"])) == 1
    assert html =~ "Admin"
  end
end
