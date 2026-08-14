defmodule MatriarchUIDocsWeb.Examples.RichEditor do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    assigns =
      assigns
      |> Map.put_new(:complete_content, complete_content())
      |> Map.put_new(:bubble_content, bubble_content())
      |> Map.put_new(:draggable_content, draggable_content())

    ~H"""
    <.example
      locale={@locale}
      title="Complete toolbar"
      description="All commands enabled by the bundled Tiptap extensions. Value controls prompt for a value unless one is passed explicitly."
      class="flex-col items-stretch"
      code={
        ~S'''
        <.rich_editor id="complete-editor" value={@complete_content}>
          <:toolbar position="top">
            <.group label="Inline formatting">
              <.toolbar_bold />
              <.toolbar_italic />
              <.toolbar_underline />
              <.toolbar_strike />
              <.toolbar_code />
              <.toolbar_highlight />
              <.toolbar_subscript />
              <.toolbar_superscript />
            </.group>
            <.group label="Text styles">
              <.toolbar_paragraph />
              <.toolbar_heading level={1} />
              <.toolbar_heading level={2} />
              <.toolbar_heading level={3} />
              <.toolbar_heading level={4} />
              <.toolbar_heading level={5} />
              <.toolbar_heading level={6} />
              <.toolbar_text_color />
              <.toolbar_background_color />
              <.toolbar_font_family />
              <.toolbar_font_size />
              <.toolbar_line_height />
            </.group>
            <.group label="Lists and blocks">
              <.toolbar_bullet_list />
              <.toolbar_ordered_list />
              <.toolbar_task_list />
              <.toolbar_sink_list_item />
              <.toolbar_lift_list_item />
              <.toolbar_blockquote />
              <.toolbar_code_block />
              <.toolbar_horizontal_rule />
              <.toolbar_hard_break />
            </.group>
            <.group label="Alignment">
              <.toolbar_align_left />
              <.toolbar_align_center />
              <.toolbar_align_right />
              <.toolbar_align_justify />
            </.group>
            <.group label="Links and media">
              <.toolbar_link />
              <.toolbar_unlink />
              <.toolbar_image />
            </.group>
            <.group label="Table">
              <.toolbar_insert_table />
              <.toolbar_add_column_before />
              <.toolbar_add_column_after />
              <.toolbar_delete_column />
              <.toolbar_add_row_before />
              <.toolbar_add_row_after />
              <.toolbar_delete_row />
              <.toolbar_delete_table />
              <.toolbar_merge_cells />
              <.toolbar_split_cell />
              <.toolbar_toggle_header_row />
              <.toolbar_toggle_header_column />
              <.toolbar_toggle_header_cell />
            </.group>
            <.group label="History">
              <.toolbar_clear_formatting />
              <.toolbar_undo />
              <.toolbar_redo />
              <.button type="button" size="sm" variant="ghost">Custom button</.button>
            </.group>
          </:toolbar>
          <:content />
        </.rich_editor>
        '''
      }
    >
      <.rich_editor id="complete-editor" value={@complete_content}>
        <:toolbar position="top">
          <.group label="Inline formatting">
            <.toolbar_bold />
            <.toolbar_italic />
            <.toolbar_underline />
            <.toolbar_strike />
            <.toolbar_code />
            <.toolbar_highlight />
            <.toolbar_subscript />
            <.toolbar_superscript />
          </.group>
          <.group label="Text styles">
            <.toolbar_paragraph />
            <.toolbar_heading level={1} />
            <.toolbar_heading level={2} />
            <.toolbar_heading level={3} />
            <.toolbar_heading level={4} />
            <.toolbar_heading level={5} />
            <.toolbar_heading level={6} />
            <.toolbar_text_color />
            <.toolbar_background_color />
            <.toolbar_font_family />
            <.toolbar_font_size />
            <.toolbar_line_height />
          </.group>
          <.group label="Lists and blocks">
            <.toolbar_bullet_list />
            <.toolbar_ordered_list />
            <.toolbar_task_list />
            <.toolbar_sink_list_item />
            <.toolbar_lift_list_item />
            <.toolbar_blockquote />
            <.toolbar_code_block />
            <.toolbar_horizontal_rule />
            <.toolbar_hard_break />
          </.group>
          <.group label="Alignment">
            <.toolbar_align_left />
            <.toolbar_align_center />
            <.toolbar_align_right />
            <.toolbar_align_justify />
          </.group>
          <.group label="Links and media">
            <.toolbar_link />
            <.toolbar_unlink />
            <.toolbar_image />
          </.group>
          <.group label="Table">
            <.toolbar_insert_table />
            <.toolbar_add_column_before />
            <.toolbar_add_column_after />
            <.toolbar_delete_column />
            <.toolbar_add_row_before />
            <.toolbar_add_row_after />
            <.toolbar_delete_row />
            <.toolbar_delete_table />
            <.toolbar_merge_cells />
            <.toolbar_split_cell />
            <.toolbar_toggle_header_row />
            <.toolbar_toggle_header_column />
            <.toolbar_toggle_header_cell />
          </.group>
          <.group label="History">
            <.toolbar_clear_formatting />
            <.toolbar_undo />
            <.toolbar_redo />
            <.button type="button" size="sm" variant="ghost">Custom button</.button>
          </.group>
        </:toolbar>
        <:content />
      </.rich_editor>
    </.example>

    <.example
      locale={@locale}
      title="Bubble toolbar"
      description="Select text to show the grouped UI-kit buttons above the selection."
      class="flex-col items-stretch"
      code={
        ~S'''
        <.rich_editor id="bubble-editor" value={@bubble_content}>
          <:toolbar position="bubble">
            <.group label="Selection formatting">
              <.toolbar_bold />
              <.toolbar_italic />
              <.toolbar_underline />
              <.toolbar_strike />
              <.toolbar_link />
            </.group>
          </:toolbar>
          <:content />
        </.rich_editor>
        '''
      }
    >
      <.rich_editor id="bubble-editor" value={@bubble_content}>
        <:toolbar position="bubble">
          <.group label="Selection formatting">
            <.toolbar_bold />
            <.toolbar_italic />
            <.toolbar_underline />
            <.toolbar_strike />
            <.toolbar_link />
          </.group>
        </:toolbar>
        <:content />
      </.rich_editor>
    </.example>

    <.example
      locale={@locale}
      title="Notion-style draggable blocks"
      description="Move the handle next to a block, then drag it to reorder the document."
      class="flex-col items-stretch"
      code={
        ~S'''
        <.rich_editor
          id="draggable-editor"
          value={@draggable_content}
        >
          <:toolbar position="bottom">
            <.group label="Block formatting">
              <.toolbar_heading level={2} />
              <.toolbar_paragraph />
              <.toolbar_bullet_list />
              <.toolbar_task_list />
            </.group>
          </:toolbar>
          <:drag_handle><.rich_editor_drag_handle /></:drag_handle>
          <:content />
        </.rich_editor>
        '''
      }
    >
      <.rich_editor
        id="draggable-editor"
        value={@draggable_content}
      >
        <:toolbar position="bottom">
          <.group label="Block formatting">
            <.toolbar_heading level={2} />
            <.toolbar_paragraph />
            <.toolbar_bullet_list />
            <.toolbar_task_list />
          </.group>
        </:toolbar>
        <:drag_handle><.rich_editor_drag_handle /></:drag_handle>
        <:content />
      </.rich_editor>
    </.example>

    <.example
      locale={@locale}
      title="Realtime collaboration"
      description="Open this page in two tabs. Phoenix Channels synchronize Yjs content, selections, names, and colored cursors."
      class="flex-col items-stretch gap-3"
      code={
        ~S'''
        <.input
          id="collaboration-user-name"
          name="collaboration-user-name"
          placeholder="Your display name"
          autocomplete="off"
        />
        <span data-mui-rich-status-for="collaboration-editor">connecting</span>
        <.rich_editor
          id="collaboration-editor"
          document="matriarch-ui-docs-rich-editor"
          user_input_id="collaboration-user-name"
        >
          <:toolbar position="top">
            <.group label="Collaborative formatting">
              <.toolbar_bold />
              <.toolbar_italic />
              <.toolbar_heading level={2} />
              <.toolbar_bullet_list />
              <.toolbar_task_list />
              <.toolbar_undo />
              <.toolbar_redo />
            </.group>
          </:toolbar>
          <:drag_handle><.rich_editor_drag_handle /></:drag_handle>
          <:content />
        </.rich_editor>
        '''
      }
    >
      <.input
        id="collaboration-user-name"
        name="collaboration-user-name"
        placeholder="Your display name"
        autocomplete="off"
      />
      <span data-mui-rich-status-for="collaboration-editor">connecting</span>
      <.rich_editor
        id="collaboration-editor"
        document="matriarch-ui-docs-rich-editor"
        user_input_id="collaboration-user-name"
      >
        <:toolbar position="top">
          <.group label="Collaborative formatting">
            <.toolbar_bold />
            <.toolbar_italic />
            <.toolbar_heading level={2} />
            <.toolbar_bullet_list />
            <.toolbar_task_list />
            <.toolbar_undo />
            <.toolbar_redo />
          </.group>
        </:toolbar>
        <:drag_handle><.rich_editor_drag_handle /></:drag_handle>
        <:content />
      </.rich_editor>
    </.example>

    <.props_table
      locale={@locale}
      rows={[
        {"id", "string", "unique id for the editor and its Tiptap hook"},
        {"field", "Phoenix.HTML.FormField", "binds id, name, and value from a form"},
        {"name", "string", "name of the hidden JSON form input"},
        {"value", "map | JSON string", "Tiptap JSON document outside collaboration mode"},
        {"editable", "boolean", "enables or disables editing"},
        {"placeholder", "string", "empty document placeholder"},
        {"character_limit", "integer", "optional character limit"},
        {"collaboration_socket", "string", "Phoenix EditorSocket path"},
        {"document", "string", "shared Yjs document name"},
        {"user_name", "string", "initial collaboration display name"},
        {"user_color", "string", "initial collaboration cursor color"},
        {"user_input_id", "string", "id of an input that edits the display name"},
        {"class", "string", "merged with the root editor classes"},
        {":toolbar", "slot", "toolbar content with top, bottom, or bubble position"},
        {":drag_handle", "slot", "optional draggable block handle template"},
        {":content", "slot", "marks the Tiptap editing surface"}
      ]}
    />
    """
  end

  defp complete_content do
    document([
      heading(2, "Everything you need"),
      paragraph("Edit this JSON document.")
    ])
  end

  defp bubble_content do
    document([paragraph("Select any part of this sentence.")])
  end

  defp draggable_content do
    document([
      heading(2, "Project notes"),
      paragraph("Drag this paragraph by its handle."),
      %{
        type: "bulletList",
        content: [%{type: "listItem", content: [paragraph("Nested blocks are supported")]}]
      }
    ])
  end

  defp document(content), do: %{type: "doc", content: content}

  defp heading(level, text) do
    %{type: "heading", attrs: %{level: level}, content: [%{type: "text", text: text}]}
  end

  defp paragraph(text), do: %{type: "paragraph", content: [%{type: "text", text: text}]}
end
