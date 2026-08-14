defmodule MatriarchUIDocsWeb.Docs.DraggablePageTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest, only: [render_component: 2]
  alias MatriarchUIDocsWeb.Examples.Draggable

  test "documents a live sortable list" do
    html = render_component(&Draggable.examples/1, %{locale: "en"})
    document = LazyHTML.from_fragment(html)

    assert document
           |> LazyHTML.query(
             ~s(#project-sections[data-mui-draggable][data-mui-document="matriarch-ui-docs-project-sections"])
           )
           |> Enum.count() ==
             1

    assert document
           |> LazyHTML.query(~s([data-mui-draggable-status-for="project-sections"]))
           |> Enum.count() == 1

    assert document
           |> LazyHTML.query(
             ~s(#project-sections template[data-mui-draggable-placeholder-template])
           )
           |> Enum.count() == 1

    assert document
           |> LazyHTML.query(~s(#project-sections > [data-mui-draggable-item]))
           |> Enum.count() == 3

    assert document
           |> LazyHTML.query(~s(#project-sections [data-mui-draggable-handle]))
           |> Enum.count() == 3
  end
end
