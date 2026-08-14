defmodule MatriarchUI.ScrollArea do
  @moduledoc "Overflow container with a thin, design-token-colored scrollbar instead of the OS default."
  use Phoenix.Component
  alias MatriarchUI.CN

  attr :orientation, :string, default: "vertical", values: ~w(vertical horizontal both)
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def scroll_area(assigns) do
    ~H"""
    <div
      data-mui
      class={
        CN.cn([
          orientation_classes(@orientation),
          "[scrollbar-width:thin] [scrollbar-color:var(--color-mui-border-strong)_transparent]",
          "[&::-webkit-scrollbar]:w-2 [&::-webkit-scrollbar]:h-2 [&::-webkit-scrollbar-track]:bg-transparent",
          "[&::-webkit-scrollbar-thumb]:rounded-mui-full [&::-webkit-scrollbar-thumb]:bg-mui-border-strong",
          "[&::-webkit-scrollbar-thumb:hover]:bg-mui-subtle-foreground",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  defp orientation_classes("vertical"), do: "overflow-y-auto overflow-x-hidden"
  defp orientation_classes("horizontal"), do: "overflow-x-auto overflow-y-hidden"
  defp orientation_classes("both"), do: "overflow-auto"
end
