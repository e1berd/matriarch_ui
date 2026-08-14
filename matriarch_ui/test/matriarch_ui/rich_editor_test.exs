defmodule MatriarchUI.RichEditorTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest, only: [render_component: 2]
  import MatriarchUI.RichEditor
  import MatriarchUI.RichEditor.DragHandle
  import MatriarchUI.RichEditor.Toolbar

  test "renders Tiptap mount point, JSON form value, toolbar, and content slots" do
    value = %{
      type: "doc",
      content: [%{type: "paragraph", content: [%{type: "text", text: "Hello"}]}]
    }

    html =
      render_component(&rich_editor/1, %{
        id: "article-body",
        name: "article[body]",
        value: value,
        toolbar: [
          %{
            position: "bubble",
            inner_block: fn _, _ ->
              Phoenix.HTML.raw(
                render_component(&toolbar_bold/1, %{}) <>
                  render_component(&toolbar_italic/1, %{})
              )
            end
          }
        ],
        content: [%{inner_block: fn _, _ -> "" end}]
      })

    assert has_element?(html, ~s(#article-body[data-mui-toolbar-position="bubble"]))

    input = html |> LazyHTML.from_fragment() |> LazyHTML.query("input#article-body-input")

    assert LazyHTML.attribute(input, "name") == ["article[body]"]
    assert LazyHTML.attribute(input, "value") == [Jason.encode!(value)]

    assert has_element?(
             html,
             ~s(#article-body[phx-hook="MatriarchUI.RichEditor.MUIRichEditor"][phx-update="ignore"] #article-body-content[data-mui-rich-content])
           )

    assert has_element?(
             html,
             ~s(#article-body-toolbar[role="toolbar"] [data-mui-rich-command="bold"])
           )

    assert has_element?(
             html,
             ~s(#article-body-toolbar [data-mui-rich-command="italic"][aria-pressed="false"])
           )
  end

  test "binds id, name, and value from a form field" do
    value = %{
      "type" => "doc",
      "content" => [
        %{"type" => "paragraph", "content" => [%{"type" => "text", "text" => "Draft"}]}
      ]
    }

    encoded_value = Jason.encode!(value)
    form = Phoenix.Component.to_form(%{"body" => encoded_value}, as: "article")

    html =
      render_component(&rich_editor/1, %{
        field: form[:body],
        toolbar: [%{inner_block: fn _, _ -> "" end}],
        content: [%{inner_block: fn _, _ -> "" end}]
      })

    assert has_element?(html, "#article_body")

    input = html |> LazyHTML.from_fragment() |> LazyHTML.query("input#article_body-input")

    assert LazyHTML.attribute(input, "name") == ["article[body]"]
    assert LazyHTML.attribute(input, "value") == [encoded_value]
  end

  test "rejects HTML content" do
    assert_raise Jason.DecodeError, fn ->
      render_component(&rich_editor/1, %{
        id: "invalid-editor",
        value: "<p>HTML is not accepted</p>",
        toolbar: [%{inner_block: fn _, _ -> "" end}],
        content: [%{inner_block: fn _, _ -> "" end}]
      })
    end
  end

  test "renders toolbar controls with the UI-kit button contract" do
    html = render_component(&toolbar_heading/1, %{level: 3})

    assert has_element?(
             html,
             ~s(button[data-mui][data-mui-control][data-mui-rich-command="heading"][data-mui-rich-value="3"])
           )
  end

  test "renders a draggable block handle template" do
    html = render_component(&rich_editor_drag_handle/1, %{})

    assert has_element?(html, ~s(template[data-mui-rich-drag-handle]))
  end

  test "renders collaboration configuration for the hook" do
    html =
      render_component(&rich_editor/1, %{
        id: "shared-notes",
        collaboration_socket: "/custom_editor_socket",
        document: "team-notes",
        user_input_id: "display-name",
        toolbar: [%{inner_block: fn _, _ -> "" end}],
        content: [%{inner_block: fn _, _ -> "" end}]
      })

    assert has_element?(
             html,
             ~s(#shared-notes[data-mui-collaboration-socket="/custom_editor_socket"][data-mui-document="team-notes"][data-mui-user-input-id="display-name"])
           )
  end

  defp has_element?(html, selector) do
    html
    |> LazyHTML.from_fragment()
    |> LazyHTML.query(selector)
    |> Enum.any?()
  end
end
