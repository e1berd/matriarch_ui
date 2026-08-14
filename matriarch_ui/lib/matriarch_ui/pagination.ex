defmodule MatriarchUI.Pagination do
  @moduledoc """
  Static page-number nav — every button fires `phx-click={@event}
  phx-value-page={n}`, you own the page state and re-render with the new
  `page`.
  """
  use Phoenix.Component
  alias MatriarchUI.CN

  attr :page, :integer, required: true
  attr :total_pages, :integer, required: true
  attr :siblings, :integer, default: 1
  attr :event, :string, default: "paginate"
  attr :target, :any, default: nil
  attr :class, :string, default: nil

  def pagination(assigns) do
    assigns =
      assign(assigns, :items, page_items(assigns.page, assigns.total_pages, assigns.siblings))

    ~H"""
    <nav data-mui aria-label="Pagination" class={CN.cn(["flex items-center gap-1", @class])}>
      <button
        type="button"
        phx-click={@event}
        phx-value-page={@page - 1}
        phx-target={@target}
        disabled={@page <= 1}
        aria-label="Previous page"
        class="flex size-8 items-center justify-center rounded-mui-md text-mui-foreground hover:bg-mui-surface-hover disabled:pointer-events-none disabled:opacity-40"
      >
        <svg class="size-4" viewBox="0 0 20 20" fill="none" aria-hidden="true">
          <path d="M12.5 5L7.5 10l5 5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
        </svg>
      </button>

      <span :for={item <- @items}>
        <span :if={item == :ellipsis} class="flex size-8 items-center justify-center text-sm text-mui-subtle-foreground">
          …
        </span>
        <button
          :if={item != :ellipsis}
          type="button"
          phx-click={@event}
          phx-value-page={item}
          phx-target={@target}
          aria-current={item == @page && "page"}
          class="flex size-8 items-center justify-center rounded-mui-md text-sm font-medium text-mui-foreground hover:bg-mui-surface-hover aria-[current=page]:bg-mui-primary aria-[current=page]:text-mui-primary-foreground aria-[current=page]:hover:bg-mui-primary"
        >
          {item}
        </button>
      </span>

      <button
        type="button"
        phx-click={@event}
        phx-value-page={@page + 1}
        phx-target={@target}
        disabled={@page >= @total_pages}
        aria-label="Next page"
        class="flex size-8 items-center justify-center rounded-mui-md text-mui-foreground hover:bg-mui-surface-hover disabled:pointer-events-none disabled:opacity-40"
      >
        <svg class="size-4" viewBox="0 0 20 20" fill="none" aria-hidden="true">
          <path d="M7.5 5l5 5-5 5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
        </svg>
      </button>
    </nav>
    """
  end

  defp page_items(_page, total_pages, _siblings) when total_pages <= 1, do: [1]

  defp page_items(page, total_pages, siblings) do
    left = max(page - siblings, 1)
    right = min(page + siblings, total_pages)

    cond do
      left > 2 and right < total_pages - 1 ->
        [1, :ellipsis] ++ Enum.to_list(left..right) ++ [:ellipsis, total_pages]

      left > 2 ->
        [1, :ellipsis] ++ Enum.to_list(left..total_pages)

      right < total_pages - 1 ->
        Enum.to_list(1..right) ++ [:ellipsis, total_pages]

      true ->
        Enum.to_list(1..total_pages)
    end
  end
end
