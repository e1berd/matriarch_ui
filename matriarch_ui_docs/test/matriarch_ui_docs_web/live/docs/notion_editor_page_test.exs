defmodule MatriarchUIDocsWeb.Docs.NotionEditorPageTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest, only: [render_component: 2]
  alias MatriarchUIDocsWeb.Examples.NotionEditor

  test "documents a collaborative draggable block editor" do
    html = render_component(&NotionEditor.examples/1, %{locale: "en"})
    document = LazyHTML.from_fragment(html)

    assert document
           |> LazyHTML.query(
             ~s(#notion-team-page[data-mui-toolbar-position="bubble"][data-mui-document="matriarch-ui-docs-notion-page"])
           )
           |> Enum.count() == 1

    assert document
           |> LazyHTML.query(~s(#notion-team-page template[data-mui-rich-drag-handle]))
           |> Enum.count() == 1

    assert document
           |> LazyHTML.query(~s(#notion-team-page-toolbar [role="group"] [data-mui-rich-command]))
           |> Enum.count() > 0

    assert document |> LazyHTML.query(~s(#notion-collaborator-name)) |> Enum.count() == 1
  end
end
