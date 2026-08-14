defmodule MatriarchUI.Spinner do
  @moduledoc "Accessible animated loading indicator."
  use Phoenix.Component
  alias MatriarchUI.CN
  import MatriarchUI.Icon

  attr :label, :string, default: "Loading"
  attr :size, :string, default: "md", values: ~w(sm md lg)
  attr :class, :string, default: nil

  def spinner(assigns) do
    ~H"""
    <span
      data-mui
      role="status"
      aria-label={@label}
      class={CN.cn(["inline-flex text-mui-muted-foreground", size_class(@size), @class])}
    >
      <.icon name="spinner-gap" class="size-full animate-spin motion-reduce:animate-none" />
    </span>
    """
  end

  defp size_class("sm"), do: "size-3.5"
  defp size_class("md"), do: "size-5"
  defp size_class("lg"), do: "size-8"
end
