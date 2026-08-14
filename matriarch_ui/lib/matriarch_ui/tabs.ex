defmodule MatriarchUI.Tabs do
  @moduledoc "Client-side tabs — no server round-trip to switch panels. The active tab gets a sliding indicator."
  use Phoenix.Component
  alias MatriarchUI.CN

  attr :id, :string, required: true
  attr :default, :string, required: true
  attr :class, :string, default: nil

  slot :tab, required: true do
    attr :value, :string, required: true
  end

  slot :panel, required: true do
    attr :value, :string, required: true
  end

  def tabs(assigns) do
    ~H"""
    <div id={@id} data-mui class={CN.cn(["flex flex-col gap-3", @class])}>
      <div
        id={"#{@id}-list"}
        role="tablist"
        phx-hook=".MUITabs"
        class="relative flex w-full gap-4 border-b border-mui-border"
      >
        <div
          data-mui-indicator
          class="absolute -bottom-px left-0 h-0.5 bg-mui-primary opacity-0 transition-[transform,width,opacity] duration-150 ease-mui-out"
        >
        </div>
        <button
          :for={tab <- @tab}
          type="button"
          role="tab"
          data-mui-tab={tab.value}
          aria-selected={to_string(to_string(tab.value) == to_string(@default))}
          tabindex={if to_string(tab.value) == to_string(@default), do: "0", else: "-1"}
          class="relative px-1 py-2 text-sm font-medium text-mui-muted-foreground transition-colors aria-selected:text-mui-primary"
        >
          {render_slot(tab)}
        </button>
      </div>
      <div
        :for={panel <- @panel}
        data-mui-panel={panel.value}
        hidden={to_string(panel.value) != to_string(@default)}
        class="text-sm text-mui-foreground"
      >
        {render_slot(panel)}
      </div>
    </div>
    """
  end

  attr :rest, :global

  def hook(assigns) do
    ~H"""
    <script :type={Phoenix.LiveView.ColocatedHook} name=".MUITabs">
      export default {
        mounted() {
          const list = this.el
          const container = list.closest("[data-mui]")
          const indicator = list.querySelector("[data-mui-indicator]")
          const tabs = () => Array.from(list.querySelectorAll('[role="tab"]'))
          const panels = () => Array.from(container.querySelectorAll("[data-mui-panel]"))

          const moveIndicator = (tab) => {
            if (!indicator || !tab) return
            indicator.style.transform = `translateX(${tab.offsetLeft - list.clientLeft}px)`
            indicator.style.width = `${tab.offsetWidth}px`
            indicator.style.opacity = "1"
          }

          const activate = (value) => {
            let activeTab = null
            tabs().forEach((tab) => {
              const selected = tab.dataset.muiTab === value
              tab.setAttribute("aria-selected", String(selected))
              tab.tabIndex = selected ? 0 : -1
              if (selected) activeTab = tab
            })
            panels().forEach((panel) => {
              panel.hidden = panel.dataset.muiPanel !== value
            })
            moveIndicator(activeTab)
          }

          list.addEventListener("click", (event) => {
            const tab = event.target.closest('[role="tab"]')
            if (tab) activate(tab.dataset.muiTab)
          })

          list.addEventListener("keydown", (event) => {
            const items = tabs()
            const current = items.indexOf(document.activeElement)
            if (current === -1) return
            let next = null
            if (event.key === "ArrowRight") next = items[(current + 1) % items.length]
            if (event.key === "ArrowLeft") next = items[(current - 1 + items.length) % items.length]
            if (event.key === "Home") next = items[0]
            if (event.key === "End") next = items[items.length - 1]
            if (next) {
              event.preventDefault()
              next.focus()
              activate(next.dataset.muiTab)
            }
          })

          const resizeObserver = new ResizeObserver(() => {
            moveIndicator(tabs().find((tab) => tab.getAttribute("aria-selected") === "true"))
          })
          resizeObserver.observe(list)

          this.muiResizeObserver = resizeObserver
        },
        destroyed() {
          if (this.muiResizeObserver) this.muiResizeObserver.disconnect()
        }
      }
    </script>
    """
  end
end
