defmodule MatriarchUI.Alert do
  @moduledoc """
  Inline callout banner — composable with `alert_title/1` and
  `alert_description/1`. Shows a variant-aware icon by default; override with
  the `:icon` slot.
  """
  use Phoenix.Component
  alias MatriarchUI.CN

  attr :variant, :string, default: "default", values: ~w(default info success warning danger)
  attr :class, :string, default: nil
  attr :rest, :global
  slot :icon
  slot :inner_block, required: true

  def alert(assigns) do
    ~H"""
    <div
      data-mui
      role="alert"
      class={
        CN.cn([
          "relative w-full rounded-mui-lg border bg-mui-surface p-4 pl-11 text-sm text-mui-foreground",
          border_classes(@variant),
          @class
        ])
      }
      {@rest}
    >
      <span class={CN.cn(["absolute left-4 top-4 size-4", icon_classes(@variant)])}>
        <%= if @icon != [] do %>
          {render_slot(@icon)}
        <% else %>
          {default_icon(@variant)}
        <% end %>
      </span>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def alert_title(assigns) do
    ~H"""
    <p class={CN.cn(["mb-1 font-medium leading-none tracking-tight", @class])}>
      {render_slot(@inner_block)}
    </p>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def alert_description(assigns) do
    ~H"""
    <p class={CN.cn(["text-mui-foreground/80", @class])}>{render_slot(@inner_block)}</p>
    """
  end

  defp border_classes("default"), do: "border-mui-border"
  defp border_classes("info"), do: "border-mui-accent/15"
  defp border_classes("success"), do: "border-mui-success/15"
  defp border_classes("warning"), do: "border-mui-warning/15"
  defp border_classes("danger"), do: "border-mui-danger/15"

  defp icon_classes("default"), do: "text-mui-foreground"
  defp icon_classes("info"), do: "text-mui-accent"
  defp icon_classes("success"), do: "text-mui-success"
  defp icon_classes("warning"), do: "text-mui-warning"
  defp icon_classes("danger"), do: "text-mui-danger"

  defp default_icon(variant) do
    assigns = %{variant: variant}

    ~H"""
    <svg :if={@variant == "default"} viewBox="0 0 20 20" fill="none" aria-hidden="true">
      <path
        d="M10 2.5c-2 0-3.5 1.6-3.5 4v2.3L5 11.7v1h10v-1l-1.5-2.9V6.5c0-2.4-1.5-4-3.5-4z"
        stroke="currentColor"
        stroke-width="1.5"
        stroke-linejoin="round"
      />
      <path d="M8.3 14.8a1.8 1.8 0 003.4 0" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" />
    </svg>
    <svg :if={@variant == "info"} viewBox="0 0 20 20" fill="none" aria-hidden="true">
      <circle cx="10" cy="10" r="7.25" stroke="currentColor" stroke-width="1.5" />
      <path d="M10 9v4.5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" />
      <circle cx="10" cy="6.5" r="0.9" fill="currentColor" />
    </svg>
    <svg :if={@variant == "success"} viewBox="0 0 20 20" fill="none" aria-hidden="true">
      <circle cx="10" cy="10" r="7.25" stroke="currentColor" stroke-width="1.5" />
      <path
        d="M7 10.2l2 2 4-4.4"
        stroke="currentColor"
        stroke-width="1.5"
        stroke-linecap="round"
        stroke-linejoin="round"
      />
    </svg>
    <svg :if={@variant == "warning"} viewBox="0 0 20 20" fill="none" aria-hidden="true">
      <path
        d="M10 3.2l7.3 12.6a1 1 0 01-.87 1.5H3.57a1 1 0 01-.87-1.5L10 3.2z"
        stroke="currentColor"
        stroke-width="1.5"
        stroke-linejoin="round"
      />
      <path d="M10 8.3v3.4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" />
      <circle cx="10" cy="14.2" r="0.9" fill="currentColor" />
    </svg>
    <svg :if={@variant == "danger"} viewBox="0 0 20 20" fill="none" aria-hidden="true">
      <circle cx="10" cy="10" r="7.25" stroke="currentColor" stroke-width="1.5" />
      <path d="M10 6.5v4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" />
      <circle cx="10" cy="13.5" r="0.9" fill="currentColor" />
    </svg>
    """
  end
end
