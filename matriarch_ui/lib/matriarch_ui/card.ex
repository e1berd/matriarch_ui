defmodule MatriarchUI.Card do
  @moduledoc """
  Composable surface container — assemble with `card_header/1`, `card_title/1`,
  `card_description/1`, `card_content/1` and `card_footer/1` instead of fixed slots.
  """
  use Phoenix.Component
  alias MatriarchUI.CN

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def card(assigns) do
    ~H"""
    <div
      data-mui
      class={
        CN.cn([
          "mui-card rounded-mui-xl border border-mui-card-border bg-mui-card-muted/30 p-1 text-mui-foreground mui-dark:bg-mui-card",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def card_header(assigns) do
    ~H"""
    <div class={CN.cn(["flex flex-col gap-1 p-3", @class])}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def card_title(assigns) do
    ~H"""
    <h3 class={CN.cn(["text-xl font-semibold leading-none tracking-tight text-mui-foreground", @class])}>
      {render_slot(@inner_block)}
    </h3>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def card_description(assigns) do
    ~H"""
    <p class={CN.cn(["text-sm text-mui-muted-foreground", @class])}>{render_slot(@inner_block)}</p>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def card_content(assigns) do
    ~H"""
    <div
      class={
        CN.cn([
          "rounded-mui-lg border border-mui-card-border bg-mui-card p-3 mui-dark:bg-mui-card-muted",
          @class
        ])
      }
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def card_footer(assigns) do
    ~H"""
    <div class={CN.cn(["flex items-center px-3 pt-1.5 pb-0.5", @class])}>
      {render_slot(@inner_block)}
    </div>
    """
  end
end
