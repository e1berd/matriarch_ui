defmodule MatriarchUI.Popover do
  @moduledoc "Click-triggered panel with arbitrary content, anchored via `.MUIFloating`."
  use Phoenix.Component
  alias MatriarchUI.{CN, Floating}

  attr :id, :string, required: true
  attr :placement, :string, default: "bottom-start"
  attr :class, :string, default: nil
  slot :trigger, required: true
  slot :inner_block, required: true

  def popover(assigns) do
    ~H"""
    <button
      type="button"
      id={"#{@id}-trigger"}
      phx-hook="MatriarchUI.Floating.MUIFloating"
      aria-controls={"#{@id}-panel"}
      aria-haspopup="dialog"
      aria-expanded="false"
      data-mui-trigger="click"
      data-mui-placement={@placement}
      class="inline-flex"
    >
      {render_slot(@trigger)}
    </button>
    <div
      id={"#{@id}-panel"}
      role="dialog"
      data-mui-state="closed"
      class={
        CN.cn([
          Floating.panel_class(),
          "min-w-56 rounded-mui-lg border border-mui-border bg-mui-surface p-4 text-sm text-mui-foreground shadow-mui-lg",
          @class
        ])
      }
    >
      {render_slot(@inner_block)}
    </div>
    """
  end
end
