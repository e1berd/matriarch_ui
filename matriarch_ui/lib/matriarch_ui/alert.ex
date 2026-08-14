defmodule MatriarchUI.Alert do
  @moduledoc """
  Inline callout banner — composable with `alert_title/1` and
  `alert_description/1`. Shows a variant-aware icon by default; override with
  the `:icon` slot.
  """
  use Phoenix.Component
  alias MatriarchUI.CN
  import MatriarchUI.Icon

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
    <.icon :if={@variant == "default"} name="bell" />
    <.icon :if={@variant == "info"} name="info" />
    <.icon :if={@variant == "success"} name="check-circle" />
    <.icon :if={@variant == "warning"} name="warning" />
    <.icon :if={@variant == "danger"} name="warning-circle" />
    """
  end
end
