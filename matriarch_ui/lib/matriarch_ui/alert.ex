defmodule MatriarchUI.Alert do
  @moduledoc "Inline callout banner for success/warning/danger/info states."
  use Phoenix.Component
  alias MatriarchUI.CN

  attr :variant, :string, default: "info", values: ~w(info success warning danger)
  attr :title, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def alert(assigns) do
    ~H"""
    <div
      data-mui
      role="alert"
      class={
        CN.cn([
          "rounded-mui-md border px-4 py-3 text-sm",
          variant_classes(@variant),
          @class
        ])
      }
      {@rest}
    >
      <p :if={@title} class="mb-1 font-semibold">{@title}</p>
      {render_slot(@inner_block)}
    </div>
    """
  end

  defp variant_classes("info") do
    "border-mui-primary-subtle bg-mui-primary-subtle text-mui-primary-subtle-foreground"
  end

  defp variant_classes("success") do
    "border-mui-success-border bg-mui-success-subtle text-mui-success"
  end

  defp variant_classes("warning") do
    "border-mui-warning-border bg-mui-warning-subtle text-mui-warning"
  end

  defp variant_classes("danger") do
    "border-mui-danger-border bg-mui-danger-subtle text-mui-danger"
  end
end
