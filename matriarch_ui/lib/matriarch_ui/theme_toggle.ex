defmodule MatriarchUI.ThemeToggle do
  @moduledoc "System/light/dark theme switch. Pairs with the app's theme bootstrap script listening for `phx:set-theme`."
  use Phoenix.Component
  alias MatriarchUI.CN
  alias MatriarchUI.Icon
  alias Phoenix.LiveView.JS

  attr :id, :string, default: "mui-theme-toggle"
  attr :system_label, :string, default: "System theme"
  attr :light_label, :string, default: "Light theme"
  attr :dark_label, :string, default: "Dark theme"
  attr :class, :string, default: nil
  attr :rest, :global

  def theme_toggle(assigns) do
    ~H"""
    <div
      id={@id}
      data-mui
      class={
        CN.cn([
          "relative flex items-center rounded-mui-full border border-mui-border bg-mui-surface-hover",
          @class
        ])
      }
      {@rest}
    >
      <div class="absolute left-0 h-full w-1/3 rounded-mui-full bg-mui-surface shadow-mui-sm transition-[left] [[data-mui-theme-mode=system]_&]:left-0 [[data-mui-theme-mode=light]_&]:left-1/3 [[data-mui-theme-mode=dark]_&]:left-2/3">
      </div>

      <button
        type="button"
        id={"#{@id}-system"}
        class="z-10 flex w-1/3 cursor-pointer p-1.5"
        aria-label={@system_label}
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
      >
        <Icon.icon name="desktop" class="size-4 text-mui-muted-foreground" />
      </button>

      <button
        type="button"
        id={"#{@id}-light"}
        class="z-10 flex w-1/3 cursor-pointer p-1.5"
        aria-label={@light_label}
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
      >
        <Icon.icon name="sun" class="size-4 text-mui-muted-foreground" />
      </button>

      <button
        type="button"
        id={"#{@id}-dark"}
        class="z-10 flex w-1/3 cursor-pointer p-1.5"
        aria-label={@dark_label}
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
      >
        <Icon.icon name="moon" class="size-4 text-mui-muted-foreground" />
      </button>
    </div>
    """
  end
end
