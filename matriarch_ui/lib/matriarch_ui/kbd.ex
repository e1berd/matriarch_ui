defmodule MatriarchUI.Kbd do
  @moduledoc """
  Renders a native `<kbd>` for a single keyboard key. Pair with `kbd_group/1`
  to show a combination — it wraps its own `<kbd>` around nested `kbd/1`
  calls, the standard HTML pattern for representing a keystroke made of
  several keys:

      <.kbd_group><.kbd>⌘</.kbd><.kbd>K</.kbd></.kbd_group>
  """
  use Phoenix.Component
  alias MatriarchUI.CN

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def kbd(assigns) do
    ~H"""
    <kbd class={
      CN.cn([
        "inline-flex min-w-[1.5em] items-center justify-center rounded border border-mui-border",
        "bg-mui-surface-hover px-1 py-0.5 text-center font-mono text-[10px] leading-none text-mui-subtle-foreground",
        @class
      ])
    }>
      {render_slot(@inner_block)}
    </kbd>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true, doc: "one or more `kbd/1` calls"

  def kbd_group(assigns) do
    ~H"""
    <kbd class={CN.cn(["inline-flex items-center gap-1", @class])}>
      {render_slot(@inner_block)}
    </kbd>
    """
  end
end
