defmodule MatriarchUI.Breadcrumb do
  @moduledoc "Static page-hierarchy trail — no JS, the last item slot is the current page."
  use Phoenix.Component
  alias MatriarchUI.CN

  attr :class, :string, default: nil

  slot :item, required: true do
    attr :navigate, :string
    attr :patch, :string
    attr :href, :string
  end

  def breadcrumb(assigns) do
    assigns = assign(assigns, :last_index, length(assigns.item) - 1)

    ~H"""
    <nav data-mui aria-label="breadcrumb" class={CN.cn(["text-sm", @class])}>
      <ol class="flex flex-wrap items-center gap-1.5">
        <li :for={{item, index} <- Enum.with_index(@item)} class="flex items-center gap-1.5">
          <.link
            :if={index != @last_index}
            navigate={item[:navigate]}
            patch={item[:patch]}
            href={item_href(item)}
            class="text-mui-muted-foreground transition-colors hover:text-mui-foreground"
            {item_rest(item)}
          >
            {render_slot(item)}
          </.link>
          <span :if={index == @last_index} aria-current="page" class="font-medium text-mui-foreground">
            {render_slot(item)}
          </span>
          <svg
            :if={index != @last_index}
            class="size-3.5 text-mui-subtle-foreground"
            viewBox="0 0 20 20"
            fill="none"
            aria-hidden="true"
          >
            <path
              d="M7.5 5l5 5-5 5"
              stroke="currentColor"
              stroke-width="1.5"
              stroke-linecap="round"
              stroke-linejoin="round"
            />
          </svg>
        </li>
      </ol>
    </nav>
    """
  end

  defp item_href(%{navigate: nav}) when is_binary(nav), do: nil
  defp item_href(%{patch: patch}) when is_binary(patch), do: nil
  defp item_href(%{href: href}) when is_binary(href), do: href
  defp item_href(_), do: "#"

  defp item_rest(item), do: Map.drop(item, [:__slot__, :inner_block, :navigate, :patch, :href])
end
