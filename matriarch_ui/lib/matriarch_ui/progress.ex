defmodule MatriarchUI.Progress do
  @moduledoc "Linear determinate or indeterminate progress indicator."
  use Phoenix.Component
  alias MatriarchUI.CN

  attr :value, :float, default: nil
  attr :max, :float, default: 100.0
  attr :label, :string, default: "Progress"
  attr :show_value, :boolean, default: false
  attr :class, :string, default: nil

  def progressbar(assigns) do
    percent = progress_percent(assigns.value, assigns.max)
    assigns = assign(assigns, :percent, percent)

    ~H"""
    <div data-mui class={CN.cn(["flex w-full flex-col gap-1.5", @class])}>
      <div :if={@show_value} class="flex items-center justify-between text-xs text-mui-muted-foreground">
        <span>{@label}</span>
        <span :if={!is_nil(@percent)}>{round(@percent)}%</span>
      </div>
      <div
        role="progressbar"
        aria-label={@label}
        aria-valuemin="0"
        aria-valuemax={@max}
        aria-valuenow={@value}
        class="h-2 w-full overflow-hidden rounded-mui-full bg-mui-border"
      >
        <div
          class={[
            "h-full rounded-mui-full bg-mui-brand transition-[width] duration-300",
            is_nil(@percent) && "mui-progress-indeterminate w-1/3"
          ]}
          style={if @percent, do: "width: #{@percent}%", else: nil}
        />
      </div>
    </div>
    """
  end

  attr :value, :float, default: nil
  attr :max, :float, default: 100.0
  attr :label, :string, default: "Progress"
  attr :show_value, :boolean, default: false
  attr :class, :string, default: nil

  def progress(assigns), do: progressbar(assigns)

  defp progress_percent(nil, _max), do: nil
  defp progress_percent(_value, max) when max <= 0, do: 0.0

  defp progress_percent(value, max),
    do: value |> Kernel./(max) |> Kernel.*(100) |> max(0) |> min(100)
end
