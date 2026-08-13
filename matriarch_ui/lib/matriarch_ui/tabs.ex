defmodule MatriarchUI.Tabs do
  @moduledoc "Client-side tabs — no server round-trip to switch panels."
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
        class="inline-flex w-fit gap-1 rounded-mui-md bg-mui-surface-hover p-1"
      >
        <button
          :for={tab <- @tab}
          type="button"
          role="tab"
          data-mui-tab={tab.value}
          aria-selected={to_string(to_string(tab.value) == to_string(@default))}
          tabindex={if to_string(tab.value) == to_string(@default), do: "0", else: "-1"}
          class="rounded-mui-sm px-3 py-1.5 text-sm font-medium text-mui-muted-foreground transition-colors aria-selected:bg-mui-surface aria-selected:text-mui-foreground aria-selected:shadow-mui-sm"
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
          const tabs = () => Array.from(list.querySelectorAll('[role="tab"]'))
          const panels = () => Array.from(container.querySelectorAll("[data-mui-panel]"))

          const activate = (value) => {
            tabs().forEach((tab) => {
              const selected = tab.dataset.muiTab === value
              tab.setAttribute("aria-selected", String(selected))
              tab.tabIndex = selected ? 0 : -1
            })
            panels().forEach((panel) => {
              panel.hidden = panel.dataset.muiPanel !== value
            })
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
        }
      }
    </script>
    """
  end
end
