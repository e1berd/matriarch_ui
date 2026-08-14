defmodule MatriarchUI.Icon do
  @moduledoc "Phosphor icon renderer backed by the phosphor_icons asset package."
  use Phoenix.Component
  alias MatriarchUI.CN

  @names ~w(
    arrow-bend-down-left arrow-right arrow-u-up-left arrow-u-up-right arrows-clockwise arrows-out-simple bell calendar-blank
    caret-down caret-left caret-right check check-circle clock code code-block columns columns-plus-left columns-plus-right desktop
    dots-six-vertical dots-three eraser eye eye-slash file folders gear git-branch github-logo google-logo highlighter house image info
    line-segment link link-break list-bullets list-checks list-numbers magnifying-glass minus moon paint-bucket palette paper-plane-tilt
    paragraph plus quotes rows rows-plus-bottom rows-plus-top selection selection-plus sidebar-simple sign-out spinner-gap sun table text-aa
    text-align-center text-align-justify text-align-left text-align-right text-b text-h-five text-h-four text-h-one text-h-six text-h-three
    text-h-two text-indent text-italic text-outdent text-strikethrough text-subscript text-superscript text-underline timer trash
    upload-simple warning warning-circle x x-circle
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
