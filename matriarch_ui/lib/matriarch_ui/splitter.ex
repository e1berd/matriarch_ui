defmodule MatriarchUI.Splitter do
  @moduledoc "Resizable panes — drag (or arrow keys on) the handle between two `:panel` slots to resize them."
  use Phoenix.Component
  alias MatriarchUI.CN
  import MatriarchUI.Icon

  attr :id, :string, required: true
  attr :orientation, :string, default: "horizontal", values: ~w(horizontal vertical)

  attr :storage_key, :string,
    default: nil,
    doc: "localStorage key panel sizes persist under and restore from"

  attr :class, :string, default: nil

  slot :panel, required: true do
    attr :default_size, :integer, doc: "percent, defaults to an even split"
    attr :min_size, :integer, doc: "percent, defaults to 0"
    attr :max_size, :integer, doc: "percent, defaults to 100"
  end

  def splitter(assigns) do
    default_size = 100 / max(length(assigns.panel), 1)
    last_index = length(assigns.panel) - 1

    assigns = assign(assigns, default_size: default_size, last_index: last_index)

    ~H"""
    <div
      id={@id}
      data-mui
      data-mui-orientation={@orientation}
      data-mui-storage-key={@storage_key}
      phx-hook=".MUISplitter"
      class={
        CN.cn([
          "flex h-full w-full",
          @orientation == "vertical" && "flex-col",
          @class
        ])
      }
    >
      <%= for {panel, index} <- Enum.with_index(@panel) do %>
        <div
          data-mui-panel
          data-mui-min-size={panel[:min_size] || 0}
          data-mui-max-size={panel[:max_size] || 100}
          data-mui-default-size={panel[:default_size] || @default_size}
          style={"flex-basis: #{panel[:default_size] || @default_size}%"}
          class="min-h-0 min-w-0 flex-1 overflow-auto"
        >
          {render_slot(panel)}
        </div>
        <div
          :if={index < @last_index}
          data-mui-handle
          role="separator"
          aria-orientation={@orientation}
          tabindex="0"
          class={[
            "group/handle relative z-10 flex shrink-0 touch-none items-center justify-center bg-mui-border outline-none transition-colors hover:bg-mui-primary focus-visible:bg-mui-primary before:absolute before:content-['']",
            @orientation == "horizontal" &&
              "w-px cursor-col-resize before:inset-y-0 before:left-1/2 before:w-6 before:-translate-x-1/2",
            @orientation == "vertical" &&
              "h-px cursor-row-resize before:inset-x-0 before:top-1/2 before:h-6 before:-translate-y-1/2"
          ]}
        >
          <.icon
            name="dots-six-vertical"
            class={
              CN.cn([
                "absolute z-10 h-8 w-5 rounded-mui-sm border border-mui-border bg-mui-surface p-1 text-mui-foreground shadow-mui-xs transition-[color,border-color,background-color]",
                "group-hover/handle:border-mui-primary group-hover/handle:text-mui-primary group-focus-visible/handle:border-mui-primary group-focus-visible/handle:text-mui-primary",
                @orientation == "vertical" && "rotate-90"
              ])
            }
          />
        </div>
      <% end %>
    </div>
    """
  end

  attr :rest, :global

  def hook(assigns) do
    ~H"""
    <script :type={Phoenix.LiveView.ColocatedHook} name=".MUISplitter">
      export default {
        mounted() {
          const root = this.el
          const orientation = root.dataset.muiOrientation || "horizontal"
          const storageKey = root.dataset.muiStorageKey
          const panels = Array.from(root.querySelectorAll("[data-mui-panel]"))

          const sizeOf = (panel) => parseFloat(panel.style.flexBasis || panel.dataset.muiDefaultSize || "50")

          const persist = () => {
            if (!storageKey) return
            localStorage.setItem(storageKey, JSON.stringify(panels.map(sizeOf)))
          }

          const restore = () => {
            if (!storageKey) return
            let stored
            try {
              stored = JSON.parse(localStorage.getItem(storageKey))
            } catch {
              return
            }
            if (!Array.isArray(stored) || stored.length !== panels.length) return
            panels.forEach((panel, index) => {
              panel.style.flexBasis = `${stored[index]}%`
            })
          }

          restore()

          const resize = (prev, next, delta, minPrev, minNext, maxPrev, maxNext) => {
            let newPrev = sizeOf(prev) + delta
            let newNext = sizeOf(next) - delta
            if (newPrev < minPrev || newNext < minNext || newPrev > maxPrev || newNext > maxNext) return
            prev.style.flexBasis = `${newPrev}%`
            next.style.flexBasis = `${newNext}%`
            persist()
          }

          Array.from(root.querySelectorAll("[data-mui-handle]")).forEach((handle) => {
            const prev = handle.previousElementSibling
            const next = handle.nextElementSibling
            if (!prev || !next) return

            const minPrev = parseFloat(prev.dataset.muiMinSize || "0")
            const minNext = parseFloat(next.dataset.muiMinSize || "0")
            const maxPrev = parseFloat(prev.dataset.muiMaxSize || "100")
            const maxNext = parseFloat(next.dataset.muiMaxSize || "100")

            handle.addEventListener("pointerdown", (event) => {
              event.preventDefault()
              const rect = root.getBoundingClientRect()
              const total = orientation === "horizontal" ? rect.width : rect.height
              const startPos = orientation === "horizontal" ? event.clientX : event.clientY
              const startPrev = sizeOf(prev)
              const startNext = sizeOf(next)

              const onMove = (moveEvent) => {
                const pos = orientation === "horizontal" ? moveEvent.clientX : moveEvent.clientY
                const deltaPercent = ((pos - startPos) / total) * 100
                let newPrev = startPrev + deltaPercent
                let newNext = startNext - deltaPercent
                if (newPrev < minPrev) newNext -= minPrev - newPrev
                if (newNext < minNext) newPrev -= minNext - newNext
                if (newPrev > maxPrev) newNext += newPrev - maxPrev
                if (newNext > maxNext) newPrev += newNext - maxNext
                newPrev = Math.min(Math.max(newPrev, minPrev), maxPrev)
                newNext = Math.min(Math.max(newNext, minNext), maxNext)
                prev.style.flexBasis = `${newPrev}%`
                next.style.flexBasis = `${newNext}%`
              }

              const onUp = () => {
                document.removeEventListener("pointermove", onMove)
                document.removeEventListener("pointerup", onUp)
                persist()
              }

              document.addEventListener("pointermove", onMove)
              document.addEventListener("pointerup", onUp)
            })

            handle.addEventListener("keydown", (event) => {
              const step = 2
              let delta = 0
              if (orientation === "horizontal" && event.key === "ArrowLeft") delta = -step
              if (orientation === "horizontal" && event.key === "ArrowRight") delta = step
              if (orientation === "vertical" && event.key === "ArrowUp") delta = -step
              if (orientation === "vertical" && event.key === "ArrowDown") delta = step
              if (delta === 0) return
              event.preventDefault()
              resize(prev, next, delta, minPrev, minNext, maxPrev, maxNext)
            })
          })
        }
      }
    </script>
    """
  end
end
