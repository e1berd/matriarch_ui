defmodule MatriarchUI.Icon do
  @moduledoc "Phosphor icon renderer backed by the phosphor_icons asset package."
  use Phoenix.Component
  alias MatriarchUI.CN

  @names ~w(
    arrow-right arrows-clockwise bell calendar-blank caret-down caret-left caret-right check check-circle
    clock desktop dots-six-vertical dots-three eye eye-slash file folders gear git-branch github-logo
    google-logo house image info magnifying-glass minus moon plus sidebar-simple sign-out spinner-gap
    sun timer trash upload-simple warning warning-circle x x-circle
  )
  @icon_directory Path.join([Mix.Project.deps_path(), "phosphor_icons", "core", "raw", "regular"])
  @icon_paths Map.new(@names, &{&1, Path.join(@icon_directory, "#{&1}.svg")})

  for {_name, path} <- @icon_paths do
    @external_resource path
  end

  @icons Map.new(@icon_paths, fn {name, path} -> {name, File.read!(path)} end)

  attr :name, :string, required: true, values: @names
  attr :label, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global

  def icon(assigns) do
    assigns = assign(assigns, :svg, Map.fetch!(@icons, assigns.name))

    ~H"""
    <span
      data-mui-icon={@name}
      role={@label && "img"}
      aria-label={@label}
      aria-hidden={to_string(is_nil(@label))}
      class={CN.cn(["inline-flex size-4 shrink-0 [&>svg]:size-full", @class])}
      {@rest}
    >
      {Phoenix.HTML.raw(@svg)}
    </span>
    """
  end
end
