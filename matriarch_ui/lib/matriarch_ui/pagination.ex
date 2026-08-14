defmodule MatriarchUI.Pagination do
  @moduledoc """
  Static page-number nav — every button fires `phx-click={@event}
  phx-value-page={n}`, you own the page state and re-render with the new
  `page`.
  """
  use Phoenix.Component
  alias MatriarchUI.CN
  alias MatriarchUI.I18n
  import MatriarchUI.Icon

  attr :id, :string, required: true
  attr :page, :integer, required: true
  attr :total_pages, :integer, required: true
  attr :siblings, :integer, default: 1
  attr :event, :string, default: "paginate"
  attr :target, :any, default: nil
  attr :locale, :string, default: "en"
  attr :class, :string, default: nil
  slot :page_size

  def pagination(assigns) do
    assigns =
      assign(assigns, :items, page_items(assigns.page, assigns.total_pages, assigns.siblings))

    ~H"""
    <div
      id={@id}
      data-mui
      class={CN.cn(["flex w-full items-center justify-between gap-4", @class])}
    >
      <div
        :if={@page_size != []}
        class="flex items-center gap-2 text-sm text-mui-muted-foreground"
      >
        <span>{I18n.t(@locale, "pagination.results_per_page")}</span>
        {render_slot(@page_size)}
      </div>
      <nav aria-label={I18n.t(@locale, "pagination.aria_label")} class="flex items-center gap-1">
      <button
        id={"#{@id}-previous"}
        type="button"
        phx-click={@event}
        phx-value-page={@page - 1}
        phx-target={@target}
        disabled={@page <= 1}
        aria-label={I18n.t(@locale, "pagination.previous_page")}
        class="flex size-8 items-center justify-center rounded-mui-md border border-mui-border bg-mui-surface text-mui-foreground transition-all hover:bg-mui-surface-hover active:scale-97 disabled:pointer-events-none disabled:opacity-40"
      >
        <.icon name="caret-left" />
      </button>

      <%= for item <- @items do %>
        <span
          :if={item == :ellipsis}
          class="flex h-9 min-w-9 items-center justify-center text-sm text-mui-subtle-foreground select-none"
        >
          …
        </span>
        <button
          :if={item != :ellipsis}
          id={"#{@id}-page-#{item}"}
          type="button"
          phx-click={@event}
          phx-value-page={item}
          phx-target={@target}
          aria-current={item == @page && "page"}
          class="flex h-8 min-w-9 items-center justify-center rounded-mui-md border border-mui-border bg-mui-surface px-2 text-sm font-medium text-mui-foreground transition-all hover:bg-mui-surface-hover active:scale-97 aria-[current=page]:border-mui-brand aria-[current=page]:bg-mui-brand aria-[current=page]:text-mui-brand-foreground aria-[current=page]:hover:bg-mui-brand-hover"
        >
          {item}
        </button>
      <% end %>

      <button
        id={"#{@id}-next"}
        type="button"
        phx-click={@event}
        phx-value-page={@page + 1}
        phx-target={@target}
        disabled={@page >= @total_pages}
        aria-label={I18n.t(@locale, "pagination.next_page")}
        class="flex size-8 items-center justify-center rounded-mui-md border border-mui-border bg-mui-surface text-mui-foreground transition-all hover:bg-mui-surface-hover active:scale-97 disabled:pointer-events-none disabled:opacity-40"
      >
        <.icon name="caret-right" />
      </button>
      </nav>
    </div>
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
