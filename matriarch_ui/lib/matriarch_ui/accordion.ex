defmodule MatriarchUI.Accordion do
  @moduledoc "Expand/collapse list of items — `type=\"single\"` closes siblings, `type=\"multiple\"` doesn't."
  use Phoenix.Component
  alias MatriarchUI.CN
  import MatriarchUI.Icon

  attr :id, :string, required: true
  attr :type, :string, default: "single", values: ~w(single multiple)
  attr :default, :list, default: [], doc: "item values open on first render"
  attr :class, :string, default: nil

  slot :item, required: true do
    attr :value, :string, required: true
    attr :title, :string, required: true
  end

  def accordion(assigns) do
    ~H"""
    <div
      id={@id}
      data-mui
      phx-hook=".MUIAccordion"
      data-mui-type={@type}
      class={CN.cn(["flex flex-col", @class])}
    >
      <div :for={item <- @item} class="border-b border-mui-border last:border-b-0">
        <h3>
          <button
            type="button"
            id={"#{@id}-#{item.value}-trigger"}
            aria-controls={"#{@id}-#{item.value}-panel"}
            aria-expanded={to_string(item.value in @default)}
            data-mui-value={item.value}
            data-mui-state={state(item.value, @default)}
            class="group flex w-full items-center justify-between gap-2 py-3.5 text-left text-sm font-medium text-mui-foreground transition-colors hover:text-mui-primary"
          >
            {item.title}
            <.icon
              name="caret-down"
              class="text-mui-subtle-foreground transition-transform duration-150 ease-mui-out group-data-[mui-state=open]:rotate-180"
            />
          </button>
        </h3>
        <div
          id={"#{@id}-#{item.value}-panel"}
          role="region"
          aria-labelledby={"#{@id}-#{item.value}-trigger"}
          data-mui-state={state(item.value, @default)}
          class="grid grid-rows-[0fr] transition-[grid-template-rows] duration-150 ease-mui-out data-[mui-state=open]:grid-rows-[1fr]"
        >
          <div class="overflow-hidden">
            <div class="pb-3.5 text-sm text-mui-muted-foreground">{render_slot(item)}</div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp state(value, default), do: if(value in default, do: "open", else: "closed")

  attr :rest, :global

  def hook(assigns) do
    ~H"""
    <script :type={Phoenix.LiveView.ColocatedHook} name=".MUIAccordion">
      export default {
        mounted() {
          const root = this.el
          const type = root.dataset.muiType || "single"
          const triggers = () => Array.from(root.querySelectorAll("[data-mui-value]"))

          const setOpen = (trigger, open) => {
            const panel = document.getElementById(trigger.getAttribute("aria-controls"))
            trigger.dataset.muiState = open ? "open" : "closed"
            trigger.setAttribute("aria-expanded", String(open))
            if (panel) panel.dataset.muiState = open ? "open" : "closed"
          }

          const toggle = (trigger) => {
            const willOpen = trigger.dataset.muiState !== "open"
            if (type === "single" && willOpen) {
              triggers().forEach((other) => other !== trigger && setOpen(other, false))
            }
            setOpen(trigger, willOpen)
          }

          root.addEventListener("click", (event) => {
            const trigger = event.target.closest("[data-mui-value]")
            if (trigger) toggle(trigger)
          })

          root.addEventListener("keydown", (event) => {
            const items = triggers()
            const current = items.indexOf(document.activeElement)
            if (current === -1) return
            let next = null
            if (event.key === "ArrowDown") next = items[(current + 1) % items.length]
            if (event.key === "ArrowUp") next = items[(current - 1 + items.length) % items.length]
            if (event.key === "Home") next = items[0]
            if (event.key === "End") next = items[items.length - 1]
            if (next) {
              event.preventDefault()
              next.focus()
            }
          })
        }
      }
    </script>
    """
  end
end
