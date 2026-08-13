defmodule MatriarchUI.Separator do
  @moduledoc "Horizontal or vertical divider line."
  use Phoenix.Component
  alias MatriarchUI.CN

  attr :orientation, :string, default: "horizontal", values: ~w(horizontal vertical)
  attr :class, :string, default: nil
  attr :rest, :global

  def separator(assigns) do
    ~H"""
    <div
      data-mui
      role="separator"
      aria-orientation={@orientation}
      class={
        CN.cn([
          "shrink-0 bg-mui-border",
          if(@orientation == "horizontal", do: "h-px w-full", else: "h-full w-px"),
          @class
        ])
      }
      {@rest}
    />
    """
  end
end
