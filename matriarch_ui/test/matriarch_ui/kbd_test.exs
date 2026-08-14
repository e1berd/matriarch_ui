defmodule MatriarchUI.KbdTest do
  use ExUnit.Case, async: true
  use Phoenix.Component
  import Phoenix.LiveViewTest
  import MatriarchUI.Kbd

  defp query(html, selector),
    do: html |> LazyHTML.from_fragment() |> LazyHTML.query(selector) |> Enum.count()

  test "renders a single key as a native kbd element" do
    html = render_component(&kbd/1, %{inner_block: [%{inner_block: fn _, _ -> "Esc" end}]})

    assert query(html, "kbd") == 1
    assert html =~ "Esc"
  end

  test "class is merged onto the rendered kbd" do
    html =
      render_component(&kbd/1, %{
        class: "text-mui-danger",
        inner_block: [%{inner_block: fn _, _ -> "X" end}]
      })

    assert query(html, "kbd.text-mui-danger") == 1
  end

  defp combo(assigns) do
    ~H"""
    <.kbd_group>
      <.kbd>⌘</.kbd><.kbd>K</.kbd>
    </.kbd_group>
    """
  end

  test "kbd_group nests kbd elements inside its own kbd, per the standard HTML pattern" do
    html = render_component(&combo/1, %{})

    assert query(html, "kbd kbd") == 2
    assert html =~ "⌘"
    assert html =~ "K"
  end
end
