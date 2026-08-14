defmodule MatriarchUI.RichEditor.DragHandle do
  @moduledoc "Drag handle template for Notion-style block reordering in `MatriarchUI.RichEditor`."
  use Phoenix.Component
  alias MatriarchUI.CN
  import MatriarchUI.Icon

  attr :label, :string, default: "Drag block"
  attr :class, :string, default: nil
  slot :inner_block

  def rich_editor_drag_handle(assigns) do
    ~H"""
    <template data-mui-rich-drag-handle>
      <div
        data-mui
        data-mui-rich-drag-control
        draggable="true"
        role="button"
        aria-label={@label}
        title={@label}
        class={
          CN.cn([
            "mui-rich-drag-handle flex size-7 items-center justify-center rounded-mui-md",
            "text-mui-muted-foreground hover:bg-mui-surface-hover hover:text-mui-foreground",
            @class
          ])
        }
      >
        <.icon :if={@inner_block == []} name="dots-six-vertical" />
        {render_slot(@inner_block)}
      </div>
    </template>
    """
  end
end
