defmodule MatriarchUIDocsWeb.Examples.NotionEditor do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      locale={@locale}
      title="Collaborative block editor"
      description="Open this page in another tab. Block order, text, selections, cursor labels, and name changes are synchronized over Phoenix Channels and Yjs."
      class="flex-col items-stretch gap-3"
      code={
        ~S'''
        <.input
          id="notion-collaborator-name"
          name="notion-collaborator-name"
          placeholder="Your display name"
          autocomplete="off"
        />
        <span data-mui-rich-status-for="notion-team-page">connecting</span>
        <.notion_editor
          id="notion-team-page"
          document="matriarch-ui-docs-notion-page"
          user_input_id="notion-collaborator-name"
        />
        '''
      }
    >
      <.input
        id="notion-collaborator-name"
        name="notion-collaborator-name"
        placeholder="Your display name"
        autocomplete="off"
      />
      <span data-mui-rich-status-for="notion-team-page">connecting</span>
      <.notion_editor
        id="notion-team-page"
        document="matriarch-ui-docs-notion-page"
        user_input_id="notion-collaborator-name"
      />
    </.example>

    <.props_table
      locale={@locale}
      rows={[
        {"id", "string", "unique editor and Tiptap hook id"},
        {"field", "Phoenix.HTML.FormField", "binds id, name, and Tiptap JSON value"},
        {"name", "string", "hidden JSON form input name"},
        {"value", "map | JSON string", "Tiptap JSON document outside collaboration mode"},
        {"editable", "boolean", "enables or disables editing"},
        {"toolbar_position", "top | bottom | bubble", "defaults to a bubble toolbar"},
        {"collaboration_socket", "string", "Phoenix EditorSocket path"},
        {"document", "string", "shared Yjs document name enabling collaboration"},
        {"user_name", "string", "initial cursor label"},
        {"user_color", "string", "initial cursor and selection color"},
        {"user_input_id", "string", "input id used to change the cursor label in realtime"},
        {"drag_handle_label", "string", "accessible block handle label"},
        {":toolbar", "slot", "optional replacement for the grouped default toolbar"}
      ]}
    />
    """
  end
end
