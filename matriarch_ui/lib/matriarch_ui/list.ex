defmodule MatriarchUI.List do
  @moduledoc "Semantic `ul`/`ol` list with composable media, content, and trailing actions."
  use Phoenix.Component
  alias MatriarchUI.CN

  attr :as, :string, default: "ul", values: ~w(ul ol)
  attr :class, :string, default: nil
  slot :inner_block, required: true

  def list(assigns) do
    ~H"""
    <.dynamic_tag
      tag_name={@as}
      data-mui
      class={CN.cn(["divide-y divide-mui-border overflow-hidden rounded-mui-lg border border-mui-border bg-mui-surface", @class])}
    >
      {render_slot(@inner_block)}
    </.dynamic_tag>
    """
  end

  attr :title, :string, default: nil
  attr :subtitle, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global
  slot :media
  slot :inner_block
  slot :trailing

  def list_item(assigns) do
    ~H"""
    <li
      data-mui
      class={CN.cn(["flex min-w-0 items-center gap-3 px-3 py-2.5 text-sm", @class])}
      {@rest}
    >
      <div :if={@media != []} class="flex shrink-0 items-center justify-center">
        {render_slot(@media)}
      </div>
      <div class="min-w-0 flex-1">
        <p :if={@title} class="truncate font-medium text-mui-foreground">{@title}</p>
        <p :if={@subtitle} class="truncate text-xs text-mui-muted-foreground">{@subtitle}</p>
        <div :if={@inner_block != []} class="text-mui-foreground">{render_slot(@inner_block)}</div>
      </div>
      <div :if={@trailing != []} class="flex shrink-0 items-center gap-1">
        {render_slot(@trailing)}
      </div>
    </li>
    """
  end
end
