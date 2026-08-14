defmodule MatriarchUI.NotionEditor do
  @moduledoc "Notion-style block editor with draggable content and Yjs collaboration."
  use Phoenix.Component
  alias MatriarchUI.CN
  import MatriarchUI.Group
  import MatriarchUI.RichEditor
  import MatriarchUI.RichEditor.DragHandle
  import MatriarchUI.RichEditor.Toolbar

  attr :id, :string, required: true
  attr :field, Phoenix.HTML.FormField, default: nil
  attr :name, :any, default: nil
  attr :value, :any, default: nil
  attr :editable, :boolean, default: true
  attr :label, :string, default: "Notion editor"
  attr :placeholder, :string, default: "Start writing…"
  attr :character_limit, :integer, default: nil
  attr :toolbar_position, :string, default: "bubble", values: ~w(top bottom bubble)
  attr :collaboration_socket, :string, default: "/editor_socket"
  attr :document, :string, default: nil
  attr :user_name, :string, default: nil
  attr :user_color, :string, default: nil
  attr :user_input_id, :string, default: nil
  attr :drag_handle_label, :string, default: "Move block"
  attr :class, :string, default: nil
  attr :content_class, :string, default: nil
  attr :rest, :global

  slot :toolbar

  def notion_editor(assigns) do
    ~H"""
    <.rich_editor
      id={@id}
      field={@field}
      name={@name}
      value={@value}
      editable={@editable}
      label={@label}
      placeholder={@placeholder}
      character_limit={@character_limit}
      collaboration_socket={@collaboration_socket}
      document={@document}
      user_name={@user_name}
      user_color={@user_color}
      user_input_id={@user_input_id}
      class={CN.cn(["rounded-none border-0 bg-transparent shadow-none", @class])}
      {@rest}
    >
      <:toolbar position={@toolbar_position}>
        <%= if @toolbar == [] do %>
          <.group label="Text formatting">
            <.toolbar_paragraph />
            <.toolbar_heading level={1} />
            <.toolbar_heading level={2} />
            <.toolbar_bold />
            <.toolbar_italic />
            <.toolbar_underline />
            <.toolbar_strike />
            <.toolbar_link />
          </.group>
          <.group label="Blocks">
            <.toolbar_bullet_list />
            <.toolbar_ordered_list />
            <.toolbar_task_list />
            <.toolbar_blockquote />
            <.toolbar_code_block />
          </.group>
        <% else %>
          {render_slot(@toolbar)}
        <% end %>
      </:toolbar>
      <:drag_handle>
        <.rich_editor_drag_handle label={@drag_handle_label} />
      </:drag_handle>
      <:content class={CN.cn(["mui-notion-editor-content", @content_class])} />
    </.rich_editor>
    """
  end
end
