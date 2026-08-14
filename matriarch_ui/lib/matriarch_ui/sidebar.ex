defmodule MatriarchUI.Sidebar do
  @moduledoc """
  App-shell navigation rail — composable with `sidebar_header/1`,
  `sidebar_content/1`, `sidebar_footer/1`, `sidebar_group/1` and
  `sidebar_menu_item/1`. `sidebar_trigger/1` toggles it: on desktop that
  collapses it to icon-only width, on mobile (below the `md` breakpoint) it
  becomes an off-canvas drawer with a backdrop. The server always renders it
  open — on a mobile viewport the colocated hook corrects that to closed on
  mount, so there's a brief flash on first paint there, same tradeoff most
  client-driven sidebars make.
  """
  use Phoenix.Component
  alias MatriarchUI.CN
  alias Phoenix.LiveView.JS
  import MatriarchUI.Icon

  attr :id, :string, required: true
  attr :class, :string, default: nil
  slot :inner_block, required: true

  def sidebar(assigns) do
    ~H"""
    <div
      id={@id}
      data-mui
      data-mui-state="open"
      phx-hook=".MUISidebar"
      class={
        CN.cn([
          "group/sidebar fixed inset-y-0 left-0 z-50 flex w-64 -translate-x-full flex-col overflow-hidden",
          "border-r border-mui-border bg-mui-surface transition-[width,transform] duration-200 ease-mui-out",
          "data-[mui-state=open]:translate-x-0",
          "md:relative md:inset-auto md:z-auto md:translate-x-0 md:data-[mui-state=closed]:w-14",
          @class
        ])
      }
    >
      {render_slot(@inner_block)}
    </div>
    <div
      data-mui-backdrop
      data-mui-state="closed"
      class="fixed inset-0 z-40 bg-mui-overlay opacity-0 pointer-events-none transition-opacity duration-150 ease-mui-out data-[mui-state=open]:opacity-100 data-[mui-state=open]:pointer-events-auto md:hidden"
    >
    </div>
    """
  end

  attr :for, :string, required: true, doc: "the sidebar's id"
  attr :class, :string, default: nil
  slot :inner_block

  def sidebar_trigger(assigns) do
    ~H"""
    <button
      type="button"
      phx-click={JS.dispatch("mui:toggle-sidebar", to: "##{@for}")}
      aria-controls={@for}
      class={
        CN.cn([
          "flex size-8 items-center justify-center rounded-mui-md text-mui-foreground hover:bg-mui-surface-hover",
          @class
        ])
      }
    >
      <%= if @inner_block != [] do %>
        {render_slot(@inner_block)}
      <% else %>
        <.icon name="sidebar-simple" />
      <% end %>
    </button>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def sidebar_header(assigns) do
    ~H"""
    <div class={CN.cn(["flex items-center gap-2 border-b border-mui-border px-2.5 py-3", @class])}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def sidebar_content(assigns) do
    ~H"""
    <div class={CN.cn(["flex-1 overflow-y-auto px-2 py-3", @class])}>{render_slot(@inner_block)}</div>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def sidebar_footer(assigns) do
    ~H"""
    <div class={CN.cn(["border-t border-mui-border p-2", @class])}>{render_slot(@inner_block)}</div>
    """
  end

  attr :label, :string, default: nil
  attr :class, :string, default: nil
  slot :inner_block, required: true

  def sidebar_group(assigns) do
    ~H"""
    <div class={CN.cn(["flex flex-col py-2", @class])}>
      <p
        :if={@label}
        class="max-h-6 overflow-hidden px-2 pb-1.5 text-[11px] font-semibold uppercase tracking-wide text-mui-subtle-foreground opacity-100 transition-[max-height,opacity,padding] duration-150 ease-mui-out group-data-[mui-state=closed]/sidebar:md:max-h-0 group-data-[mui-state=closed]/sidebar:md:pb-0 group-data-[mui-state=closed]/sidebar:md:opacity-0"
      >
        {@label}
      </p>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :navigate, :string, default: nil
  attr :patch, :string, default: nil
  attr :href, :string, default: nil
  attr :active, :boolean, default: false
  attr :class, :string, default: nil
  slot :icon
  slot :inner_block, required: true

  def sidebar_menu_item(assigns) do
    ~H"""
    <.link
      navigate={@navigate}
      patch={@patch}
      href={@href}
      class={
        CN.cn([
          "flex min-h-7 items-center gap-2 rounded-mui-md px-2 py-1 text-[13px] font-normal text-mui-muted-foreground",
          "group-data-[mui-state=closed]/sidebar:md:justify-center group-data-[mui-state=closed]/sidebar:md:gap-0 group-data-[mui-state=closed]/sidebar:md:px-0",
          "hover:bg-mui-surface-hover hover:text-mui-foreground",
          @active && "bg-mui-primary-subtle text-mui-primary-subtle-foreground hover:bg-mui-primary-subtle",
          @class
        ])
      }
    >
      <span :if={@icon != []} class="flex size-4 shrink-0 items-center justify-center">{render_slot(@icon)}</span>
      <span class="max-w-48 truncate opacity-100 transition-[max-width,opacity] duration-150 ease-mui-out group-data-[mui-state=closed]/sidebar:md:max-w-0 group-data-[mui-state=closed]/sidebar:md:opacity-0">
        {render_slot(@inner_block)}
      </span>
    </.link>
    """
  end

  attr :rest, :global

  def hook(assigns) do
    ~H"""
    <script :type={Phoenix.LiveView.ColocatedHook} name=".MUISidebar">
      export default {
        mounted() {
          const sidebar = this.el
          const backdrop = sidebar.nextElementSibling
          const isMobile = () => window.matchMedia("(max-width: 767px)").matches

          const setState = (state) => {
            sidebar.dataset.muiState = state
            if (backdrop) backdrop.dataset.muiState = isMobile() && state === "open" ? "open" : "closed"
          }

          sidebar.addEventListener("mui:toggle-sidebar", () => {
            setState(sidebar.dataset.muiState === "open" ? "closed" : "open")
          })

          backdrop?.addEventListener("click", () => setState("closed"))

          if (isMobile()) setState("closed")
        }
      }
    </script>
    """
  end
end
