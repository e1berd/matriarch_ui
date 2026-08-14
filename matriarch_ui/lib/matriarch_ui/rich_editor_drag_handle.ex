defmodule MatriarchUI.RichEditor.DragHandle do
  @moduledoc "Drag handle template for block reordering in `MatriarchUI.RichEditor`."
  use Phoenix.Component
  alias MatriarchUI.CN
  import MatriarchUI.Draggable

  attr(:label, :string, default: "Drag block")
  attr(:class, :string, default: nil)
  slot(:inner_block)

  def rich_editor_drag_handle(assigns) do
    ~H"""
    <template data-mui-rich-drag-handle>
      <%= if @inner_block == [] do %>
        <.draggable_handle
          label={@label}
          class={CN.cn(["mui-rich-drag-handle", @class])}
        />
      <% else %>
        <.draggable_handle label={@label} class={CN.cn(["mui-rich-drag-handle", @class])}>
          {render_slot(@inner_block)}
        </.draggable_handle>
      <% end %>
    </template>
    """
  end
end
