defmodule MatriarchUI.Group do
  @moduledoc "Visually joins adjacent controls into one horizontal or vertical unit."
  use Phoenix.Component
  alias MatriarchUI.CN

  attr :orientation, :string, default: "horizontal", values: ~w(horizontal vertical)
  attr :label, :string, default: nil
  attr :class, :string, default: nil
  slot :inner_block, required: true

  def group(assigns) do
    ~H"""
    <div
      data-mui
      data-mui-orientation={@orientation}
      role="group"
      aria-label={@label}
      class={
        CN.cn([
          "mui-control-group isolate inline-flex items-stretch [&>*:focus-within]:z-10",
          @orientation == "vertical" && "flex-col",
          @class
        ])
      }
    >
      {render_slot(@inner_block)}
    </div>
    """
  end
end
