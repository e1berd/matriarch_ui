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
          "border-r border-mui-border bg-mui-surface transition-[width,transform] duration-150 ease-mui-out",
          "data-[mui-state=open]:translate-x-0",
          "md:relative md:inset-auto md:z-auto md:translate-x-0 md:data-[mui-state=closed]:w-16",
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
        <svg class="size-4" viewBox="0 0 20 20" fill="none" aria-hidden="true">
          <path d="M3 5h14M3 10h14M3 15h14" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" />
        </svg>
      <% end %>
    </button>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def sidebar_header(assigns) do
    ~H"""
    <div class={CN.cn(["flex items-center gap-2 border-b border-mui-border px-3 py-3", @class])}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def sidebar_content(assigns) do
    ~H"""
    <div class={CN.cn(["flex-1 overflow-y-auto p-2", @class])}>{render_slot(@inner_block)}</div>
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
    <div class={CN.cn(["flex flex-col gap-0.5 py-2", @class])}>
      <p
        :if={@label}
        class="px-2.5 pb-1 text-xs font-medium uppercase text-mui-subtle-foreground group-data-[mui-state=closed]/sidebar:md:hidden"
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
          "flex items-center gap-2.5 rounded-mui-md px-2.5 py-2 text-sm font-medium text-mui-muted-foreground transition-colors",
          "hover:bg-mui-surface-hover hover:text-mui-foreground",
          @active && "bg-mui-primary-subtle text-mui-primary-subtle-foreground hover:bg-mui-primary-subtle",
          @class
        ])
      }
    >
      <span :if={@icon != []} class="size-4 shrink-0">{render_slot(@icon)}</span>
      <span class="truncate group-data-[mui-state=closed]/sidebar:md:hidden">{render_slot(@inner_block)}</span>
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
