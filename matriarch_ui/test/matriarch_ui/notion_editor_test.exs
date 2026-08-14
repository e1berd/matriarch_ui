defmodule MatriarchUI.NotionEditorTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest, only: [render_component: 2]
  import MatriarchUI.NotionEditor

  test "renders draggable Notion blocks with grouped bubble controls" do
    value = %{type: "doc", content: [%{type: "paragraph"}]}

    html =
      render_component(&notion_editor/1, %{
        id: "workspace",
        name: "page[content]",
        value: value
      })

    assert has_element?(
             html,
             ~s(#workspace[data-mui-toolbar-position="bubble"] template[data-mui-rich-drag-handle])
           )

    assert has_element?(
             html,
             ~s(#workspace-toolbar[role="toolbar"] [role="group"] [data-mui-rich-command="bold"])
           )

    input = html |> LazyHTML.from_fragment() |> LazyHTML.query("#workspace-input")
    assert LazyHTML.attribute(input, "name") == ["page[content]"]
    assert LazyHTML.attribute(input, "value") == [Jason.encode!(value)]
  end

  test "forwards realtime collaboration and cursor identity" do
    html =
      render_component(&notion_editor/1, %{
        id: "team-page",
        document: "team-page-42",
        collaboration_socket: "/team_editor_socket",
        user_name: "Mira",
        user_color: "var(--color-mui-collaborator-2)",
        user_input_id: "team-user-name"
      })

    assert has_element?(
             html,
             ~s(#team-page[data-mui-document="team-page-42"][data-mui-collaboration-socket="/team_editor_socket"][data-mui-user-name="Mira"][data-mui-user-input-id="team-user-name"])
           )
  end

  defp has_element?(html, selector) do
    html
    |> LazyHTML.from_fragment()
    |> LazyHTML.query(selector)
    |> Enum.any?()
  end
end
