defmodule MatriarchUI.Badge do
  @moduledoc "Small status/label pill."
  use Phoenix.Component
  alias MatriarchUI.CN

  attr :variant, :string,
    default: "neutral",
    values: ~w(neutral primary success warning danger outline)

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def badge(assigns) do
    ~H"""
    <span
      data-mui
      class={
        CN.cn([
          "inline-flex items-center gap-1 rounded-mui-full px-2.5 py-0.5 text-xs font-medium",
          variant_classes(@variant),
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </span>
    """
  end

  defp variant_classes("neutral"), do: "bg-mui-surface-hover text-mui-muted-foreground"
  defp variant_classes("primary"), do: "bg-mui-primary-subtle text-mui-primary-subtle-foreground"

  defp variant_classes("success") do
    "bg-mui-success-subtle text-mui-success border border-mui-success-border"
  end

  defp variant_classes("warning") do
    "bg-mui-warning-subtle text-mui-warning border border-mui-warning-border"
  end

  defp variant_classes("danger") do
    "bg-mui-danger-subtle text-mui-danger border border-mui-danger-border"
  end

  defp variant_classes("outline") do
    "border border-mui-border text-mui-foreground"
  end
end
