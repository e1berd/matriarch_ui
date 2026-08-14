defmodule MatriarchUIDocsWeb.Docs.RichEditorPageTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest, only: [render_component: 2]
  alias MatriarchUIDocsWeb.Examples.RichEditor

  test "documents complete, bubble, outliner, and collaborative live editors" do
    html = render_component(&RichEditor.examples/1, %{locale: "en"})
    document = LazyHTML.from_fragment(html)

    assert document |> LazyHTML.query(~s([data-mui-toolbar-position="top"])) |> Enum.count() == 2

    assert document |> LazyHTML.query(~s([data-mui-toolbar-position="bubble"])) |> Enum.count() ==
             2

    assert document
           |> LazyHTML.query(~s([phx-hook="MatriarchUI.RichEditor.MUIRichEditor"]))
           |> Enum.count() == 4

    assert document
           |> LazyHTML.query(
             ~s(#bubble-editor-toolbar [role="group"] [data-mui-control][data-mui-rich-command])
           )
           |> Enum.count() == 5

    assert document
           |> LazyHTML.query(
             ~s(#outliner-editor[data-mui-toolbar-position="bubble"] #outliner-editor-content.mui-outliner-content)
           )
           |> Enum.count() == 1

    assert document
           |> LazyHTML.query(~s(template[data-mui-rich-drag-handle]))
           |> Enum.count() == 2

    assert document
           |> LazyHTML.query(
             ~s(#collaboration-editor[data-mui-collaboration-socket="/editor_socket"][data-mui-document="matriarch-ui-docs-rich-editor"])
           )
           |> Enum.count() == 1

    assert document
           |> LazyHTML.query(~s(input#collaboration-user-name))
           |> Enum.count() == 1

    assert document
           |> LazyHTML.query(~s(#collaboration-editor-content.text-left))
           |> Enum.count() == 1
  end
end
