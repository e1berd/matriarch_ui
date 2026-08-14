defmodule MatriarchUI.DraggableTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest, only: [render_component: 2]
  import MatriarchUI.Draggable

  test "renders sortable items, handles, and JSON order input" do
    html =
      render_component(&draggable/1, %{
        id: "priority-list",
        name: "project[order]",
        event: "sort_tasks",
        target: "#project",
        document: "project-sections",
        item: [
          %{
            id: "first",
            inner_block: fn _, _ ->
              Phoenix.HTML.raw(render_component(&draggable_handle/1, %{}))
            end
          },
          %{
            id: "second",
            disabled: true,
            inner_block: fn _, _ ->
              Phoenix.HTML.raw(render_component(&draggable_handle/1, %{label: "Move second"}))
            end
          }
        ]
      })

    assert has_element?(
             html,
             ~s(#priority-list[phx-hook="MatriarchUI.Draggable.MUIDraggable"][data-mui-reorder-event="sort_tasks"][data-mui-reorder-target="#project"][data-mui-document="project-sections"])
           )

    assert has_element?(
             html,
             ~s(#priority-list template[data-mui-draggable-placeholder-template])
           )

    assert has_element?(
             html,
             ~s(#priority-list-item-first[data-mui-item-id="first"] [data-mui-draggable-handle][aria-grabbed="false"])
           )

    assert has_element?(
             html,
             ~s(#priority-list-item-second[data-mui-disabled="true"] [aria-label="Move second"])
           )

    input = html |> LazyHTML.from_fragment() |> LazyHTML.query("#priority-list-order")
    assert LazyHTML.attribute(input, "name") == ["project[order]"]
    assert LazyHTML.attribute(input, "value") == [~s(["first","second"])]
  end

  test "renders a disabled standalone handle" do
    html = render_component(&draggable_handle/1, %{disabled: true, label: "Locked"})

    assert has_element?(
             html,
             ~s(button[data-mui-draggable-handle][disabled][draggable="false"][aria-label="Locked"])
           )
  end

  defp has_element?(html, selector) do
    html
    |> LazyHTML.from_fragment()
    |> LazyHTML.query(selector)
    |> Enum.any?()
  end
end
