defmodule MatriarchUI.Button do
  @moduledoc """
  Button primitive: solid/outline/ghost/soft/destructive/link variants.
  Renders as `<.link>` instead of `<button>` when `href`/`navigate`/`patch` is given.
  """
  use Phoenix.Component
  alias MatriarchUI.CN

  attr(:type, :string, default: "button")

  attr(:variant, :string,
    default: "solid",
    values: ~w(solid outline ghost soft destructive link)
  )

  attr(:size, :string, default: "md", values: ~w(sm md lg icon))
  attr(:loading, :boolean, default: false)
  attr(:disabled, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(form name value navigate patch href method))
  slot(:inner_block, required: true)
  slot(:icon)

  def button(%{rest: rest} = assigns) do
    assigns =
      assign(
        assigns,
        :class,
        CN.cn([
          "inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-mui-sm font-medium leading-none",
          "transition-colors duration-150 disabled:pointer-events-none disabled:opacity-50",
          size_classes(assigns.size),
          variant_classes(assigns.variant),
          assigns.class
        ])
      )

    if rest[:href] || rest[:navigate] || rest[:patch] do
      ~H"""
      <.link data-mui class={@class} {@rest}>
        {render_slot(@inner_block)}
      </.link>
      """
    else
      ~H"""
      <button type={@type} disabled={@disabled || @loading} data-mui class={@class} {@rest}>
        <svg
          :if={@loading}
          class="size-4 animate-spin"
          viewBox="0 0 24 24"
          fill="none"
          aria-hidden="true"
        >
          <circle
            class="opacity-25"
            cx="12"
            cy="12"
            r="10"
            stroke="currentColor"
            stroke-width="4"
          />
          <path
            class="opacity-75"
            fill="currentColor"
            d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"
          />
        </svg>
        <span :if={!@loading && @icon != []} class="-ml-0.5 size-4">{render_slot(@icon)}</span>
        {render_slot(@inner_block)}
      </button>
      """
    end
  end

  defp size_classes("sm"), do: "h-7 px-2.5 text-xs gap-1"
  defp size_classes("md"), do: "h-[30px] px-3 text-[13px] gap-1.5"
  defp size_classes("lg"), do: "h-10 px-4 text-sm gap-2"
  defp size_classes("icon"), do: "size-[30px] p-0"

  defp variant_classes("solid") do
    gloss_classes("ring-mui-primary", "bg-mui-primary", "text-mui-primary-foreground")
  end

  defp variant_classes("outline") do
    "border border-mui-border-strong bg-mui-surface text-mui-foreground shadow-mui-xs hover:bg-mui-surface-hover"
  end

  defp variant_classes("ghost") do
    "text-mui-foreground hover:bg-mui-surface-hover"
  end

  defp variant_classes("soft") do
    "bg-mui-primary-subtle text-mui-primary-subtle-foreground hover:bg-mui-primary-subtle/70"
  end

  defp variant_classes("destructive") do
    gloss_classes("ring-mui-danger", "bg-mui-danger", "text-mui-danger-foreground")
  end

  defp variant_classes("link") do
    "h-auto! p-0! text-mui-primary underline-offset-4 hover:underline"
  end

  defp gloss_classes(ring_color, bg_color, text_color) do
    "relative isolate overflow-hidden" <>
      " ring-[0.5px] #{ring_color} #{bg_color} #{text_color} shadow-mui-button" <>
      " transition duration-300 ease-mui-out" <>
      " before:absolute before:inset-0 before:-z-10 before:rounded-[inherit] before:pointer-events-none" <>
      " before:bg-linear-to-b before:from-white/20 before:opacity-50 before:transition-opacity" <>
      " before:duration-300 before:ease-mui-out hover:before:opacity-100" <>
      " after:absolute after:inset-0 after:-z-10 after:rounded-[inherit] after:pointer-events-none" <>
      " after:bg-linear-to-b after:from-white/10 after:from-46% after:to-54% after:mix-blend-overlay"
  end
end
