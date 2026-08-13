defmodule MatriarchUI.Card do
  @moduledoc "Surface container with optional header/footer slots."
  use Phoenix.Component
  alias MatriarchUI.CN

  attr :class, :string, default: nil
  attr :rest, :global
  slot :header
  slot :footer
  slot :inner_block, required: true

  def card(assigns) do
    ~H"""
    <div
      data-mui
      class={
        CN.cn([
          "rounded-mui-lg border border-mui-border bg-mui-surface text-mui-foreground shadow-mui-sm",
          @class
        ])
      }
      {@rest}
    >
      <div :if={@header != []} class="border-b border-mui-border px-4 py-3.5">
        {render_slot(@header)}
      </div>
      <div class="px-4 py-3.5">{render_slot(@inner_block)}</div>
      <div :if={@footer != []} class="border-t border-mui-border px-4 py-3.5">
        {render_slot(@footer)}
      </div>
    </div>
    """
  end
end
