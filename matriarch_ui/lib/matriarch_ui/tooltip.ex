defmodule MatriarchUI.Tooltip do
  @moduledoc "Hover/focus-triggered label anchored to its trigger via `.MUIFloating`."
  use Phoenix.Component
  alias MatriarchUI.{CN, Floating}

  attr :id, :string, required: true
  attr :text, :string, required: true

  attr :placement, :string,
    default: "top",
    doc:
      ~s(a side like "top"/"bottom-start", or "auto" to pick top/bottom based on available room)

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def tooltip(assigns) do
    ~H"""
    <span
      id={"#{@id}-trigger"}
      phx-hook="MatriarchUI.Floating.MUIFloating"
      aria-controls={"#{@id}-panel"}
      aria-expanded="false"
      data-mui-trigger="hover"
      data-mui-placement={@placement}
      data-mui-offset="6"
      tabindex="0"
      class="inline-flex"
    >
      {render_slot(@inner_block)}
    </span>
    <div
      id={"#{@id}-panel"}
      role="tooltip"
      data-mui-state="closed"
      class={
        CN.cn([
          Floating.panel_class(),
          "group max-w-64 rounded-mui-sm bg-mui-foreground px-2.5 py-1.5 text-xs text-mui-background shadow-mui-md",
          @class
        ])
      }
    >
      {@text}
      <span
        data-mui-arrow
        class="absolute size-2 rotate-45 bg-mui-foreground group-data-[mui-placement^=top]:-bottom-1 group-data-[mui-placement^=bottom]:-top-1 group-data-[mui-placement^=left]:-right-1 group-data-[mui-placement^=right]:-left-1"
      >
      </span>
    </div>
    """
  end
end
