defmodule MatriarchUI.Avatar do
  @moduledoc "User avatar with image fallback to initials."
  use Phoenix.Component
  alias MatriarchUI.CN

  attr :src, :string, default: nil
  attr :alt, :string, default: ""
  attr :initials, :string, default: nil
  attr :size, :string, default: "md", values: ~w(xs sm md lg xl)
  attr :class, :string, default: nil
  attr :rest, :global

  def avatar(assigns) do
    ~H"""
    <span
      data-mui
      class={
        CN.cn([
          "inline-flex shrink-0 items-center justify-center overflow-hidden rounded-mui-full bg-mui-primary-subtle font-medium text-mui-primary-subtle-foreground",
          size_classes(@size),
          @class
        ])
      }
      {@rest}
    >
      <img :if={@src} src={@src} alt={@alt} class="size-full object-cover" />
      <span :if={!@src}>{@initials}</span>
    </span>
    """
  end

  defp size_classes("xs"), do: "size-6 text-xs"
  defp size_classes("sm"), do: "size-8 text-xs"
  defp size_classes("md"), do: "size-10 text-sm"
  defp size_classes("lg"), do: "size-12 text-base"
  defp size_classes("xl"), do: "size-16 text-lg"
end
