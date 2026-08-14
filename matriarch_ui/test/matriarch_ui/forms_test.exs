defmodule MatriarchUI.FormsTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest
  import MatriarchUI.{Input, Textarea, Checkbox, Switch, RadioGroup, Select, Autocomplete}

  defp count(html, selector),
    do: html |> LazyHTML.from_fragment() |> LazyHTML.query(selector) |> Enum.count()

  test "input renders name and value from plain assigns" do
    html =
      render_component(&input/1, %{name: "user_email", id: "email", value: "a@b.com"})

    assert count(html, ~s(input[name="user_email"][value="a@b.com"])) == 1
  end

  test "input applies the danger border and aria-invalid when invalid" do
    html = render_component(&input/1, %{name: "email", id: "email", invalid: true})
    assert count(html, "input.border-mui-danger") == 1
    assert count(html, ~s(input[aria-invalid="true"])) == 1
  end

  test "textarea renders the given value as its content" do
    html = render_component(&textarea/1, %{name: "bio", id: "bio", value: "hello world"})
    assert html =~ "hello world"
    assert count(html, "textarea#bio") == 1
  end

  test "checkbox marks the input checked and keeps a hidden fallback field" do
    html = render_component(&checkbox/1, %{name: "tos", id: "tos", checked: true})

    assert count(html, ~s(input[type="hidden"][name="tos"][value="false"])) == 1
    assert count(html, ~s(input[type="checkbox"]#tos[checked])) == 1
  end

  test "checkbox exposes the indeterminate state with a Phosphor indicator" do
    html = render_component(&checkbox/1, %{name: "all", id: "all", indeterminate: true})

    assert count(html, ~s(input[type="checkbox"]#all[aria-checked="mixed"])) == 1
    assert count(html, ~s([data-mui-icon="minus"])) == 1
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
    assert count(html, ~s([role="option"][data-mui-label])) == 0
    assert html =~ "Admin"
  end

  test "autocomplete renders a text input trigger and one option per slot entry" do
    html =
      render_component(&autocomplete/1, %{
        id: "city",
        name: "city",
        value: "Ber",
        option: [
          %{value: "Berlin", inner_block: fn _, _ -> "Berlin" end},
          %{value: "Bern", inner_block: fn _, _ -> "Bern" end}
        ]
      })

    assert count(html, ~s(input[type="text"][name="city"][value="Ber"])) == 1

    assert count(
             html,
             ~s(input[data-mui-trigger="focus"][data-mui-axis="vertical"][data-mui-filter="true"][data-mui-match-width="true"])
           ) == 1

    assert count(html, ~s([role="option"])) == 2
    assert html =~ "Berlin"
  end

  test "multiple select renders a native multiple value target and selected checkmarks" do
    html =
      render_component(&select/1, %{
        id: "roles",
        name: "roles",
        value: ["admin", "editor"],
        multiple: true,
        option: [
          %{value: "admin", inner_block: fn _, _ -> "Admin" end},
          %{value: "editor", inner_block: fn _, _ -> "Editor" end},
          %{value: "viewer", inner_block: fn _, _ -> "Viewer" end}
        ]
      })

    assert count(html, ~s(select#roles-value[name="roles[]"][multiple])) == 1
    assert count(html, ~s(select#roles-value option[selected])) == 2
    assert count(html, ~s(button[data-mui-multiple="true"])) == 1
    assert count(html, ~s([role="listbox"][aria-multiselectable="true"])) == 1
    assert count(html, ~s([role="option"][aria-selected="true"])) == 2
    assert count(html, ~s([role="option"] [data-mui-icon="check"])) == 3
  end

  test "select panel matches the trigger width" do
    html =
      render_component(&select/1, %{
        id: "role",
        option: [%{value: "admin", inner_block: fn _, _ -> "Admin" end}]
      })

    assert count(html, ~s(button[data-mui-match-width="true"])) == 1
  end

  test "autocomplete shows a no-results message when :option is empty" do
    html = render_component(&autocomplete/1, %{id: "city", name: "city", option: []})
    assert html =~ "No results"
  end
end
