defmodule MatriarchUI.Draggable do
  @moduledoc "Accessible sortable items with mouse, touchpad, and keyboard reordering."
  use Phoenix.Component
  alias MatriarchUI.CN
  import MatriarchUI.Icon

  attr(:id, :string, required: true)
  attr(:orientation, :string, default: "vertical", values: ~w(vertical horizontal))
  attr(:event, :string, default: "reorder")
  attr(:target, :string, default: nil)
  attr(:name, :string, default: nil)
  attr(:collaboration_socket, :string, default: "/editor_socket")
  attr(:document, :string, default: nil)
  attr(:animation_duration, :integer, default: 240)
  attr(:disabled, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:item_class, :string, default: nil)

  slot :preview do
    attr(:class, :string)
  end

  slot :item, required: true do
    attr(:id, :string, required: true)
    attr(:disabled, :boolean)
    attr(:class, :string)
  end

  def draggable(assigns) do
    preview = List.first(assigns.preview)

    assigns =
      assign(assigns,
        order_json: Jason.encode!(Enum.map(assigns.item, & &1.id)),
        preview_class: preview && Map.get(preview, :class),
        preview_content?: preview && Map.get(preview, :inner_block)
      )

    ~H"""
    <div
      id={@id}
      data-mui
      data-mui-draggable
      data-mui-orientation={@orientation}
      data-mui-reorder-event={@event}
      data-mui-reorder-target={@target}
      data-mui-collaboration-socket={@collaboration_socket}
      data-mui-document={@document}
      data-mui-animation-duration={@animation_duration}
      data-mui-disabled={to_string(@disabled)}
      phx-hook=".MUIDraggable"
      role="list"
      aria-orientation={@orientation}
      class={CN.cn(["flex", @orientation == "vertical" && "flex-col", @class])}
    >
      <input
        :if={@name}
        id={"#{@id}-order"}
        data-mui-draggable-order
        type="hidden"
        name={@name}
        value={@order_json}
      />
      <template data-mui-draggable-placeholder-template>
        <div
          data-mui-draggable-placeholder
          aria-hidden="true"
          class={
            CN.cn([
              "min-h-2 rounded-mui-md border border-mui-border-strong bg-mui-surface-hover",
              @preview_class
            ])
          }
        >
          <%= if @preview_content? do %>
            {render_slot(@preview)}
          <% end %>
        </div>
      </template>
      <div
        :for={item <- @item}
        id={"#{@id}-item-#{item.id}"}
        data-mui-draggable-item
        data-mui-item-id={item.id}
        data-mui-disabled={to_string(@disabled or Map.get(item, :disabled, false))}
        role="listitem"
        class={CN.cn(["relative", @item_class, Map.get(item, :class)])}
      >
        {render_slot(item)}
      </div>
    </div>
    """
  end

  attr(:label, :string, default: "Drag item")
  attr(:disabled, :boolean, default: false)
  attr(:class, :string, default: nil)
  slot(:inner_block)

  def draggable_handle(assigns) do
    ~H"""
    <button
      type="button"
      data-mui
      data-mui-draggable-handle
      draggable={to_string(not @disabled)}
      disabled={@disabled}
      aria-label={@label}
      aria-grabbed="false"
      title={@label}
      class={
        CN.cn([
          "mui-drag-handle flex size-7 shrink-0 cursor-grab touch-none items-center justify-center rounded-mui-md",
          "text-mui-foreground hover:bg-mui-surface-hover hover:text-mui-foreground",
          "active:cursor-grabbing disabled:pointer-events-none disabled:opacity-40",
          @class
        ])
      }
    >
      <.icon :if={@inner_block == []} name="dots-six-vertical" />
      {render_slot(@inner_block)}
    </button>
    """
  end

  attr(:rest, :global)

  def hook(assigns) do
    ~H"""
    <script :type={Phoenix.LiveView.ColocatedHook} name=".MUIDraggable">
      const itemSelector = ":scope > [data-mui-draggable-item]"
      const realtimeSockets = new Map()

      function acquireSocket(liveSocket, path) {
        const existing = realtimeSockets.get(path)
        if (existing) {
          existing.references += 1
          return {socket: existing.socket, release: () => releaseSocket(path)}
        }
        const Socket = liveSocket.getSocket().constructor
        const csrfToken = document.querySelector("meta[name='csrf-token']")?.content
        const socket = new Socket(path, {params: {_csrf_token: csrfToken}})
        socket.connect()
        realtimeSockets.set(path, {socket, references: 1})
        return {socket, release: () => releaseSocket(path)}
      }

      function releaseSocket(path) {
        const entry = realtimeSockets.get(path)
        if (!entry) return
        entry.references -= 1
        if (entry.references > 0) return
        entry.socket.disconnect()
        realtimeSockets.delete(path)
      }

      export default {
        mounted() {
          this.items = () => Array.from(this.el.querySelectorAll(itemSelector))
          this.order = () => this.items().map(item => item.dataset.muiItemId)
          this.duration = () => {
            const duration = Number(this.el.dataset.muiAnimationDuration)
            return Number.isFinite(duration) && duration >= 0 ? duration : 240
          }
          this.easing = getComputedStyle(document.documentElement).getPropertyValue("--ease-mui-out").trim() || "cubic-bezier(0.4, 0.36, 0, 1)"
          this.motionEnabled = () => this.duration() > 0 && !matchMedia("(prefers-reduced-motion: reduce)").matches
          this.positions = () => new Map(this.items().filter(item => item !== this.dragged).map(item => [item, item.getBoundingClientRect()]))
          this.animateFrom = (positions) => {
            if (!this.motionEnabled()) return
            this.items().forEach((item) => {
              const previous = positions.get(item)
              if (!previous || item === this.dragged) return
              const current = item.getBoundingClientRect()
              const x = previous.left - current.left
              const y = previous.top - current.top
              if (x === 0 && y === 0) return
              item.animate(
                [{transform: `translate(${x}px, ${y}px)`}, {transform: "translate(0, 0)"}],
                {duration: this.duration(), easing: this.easing},
              )
            })
          }
          this.writeOrder = (order) => {
            const input = this.el.querySelector("[data-mui-draggable-order]")
            if (!input) return
            input.value = JSON.stringify(order)
            input.dispatchEvent(new Event("input", {bubbles: true}))
          }
          this.notify = (moved, previousIndex, origin) => {
            const order = this.order()
            const detail = {
              id: moved?.dataset.muiItemId || null,
              old_index: previousIndex,
              new_index: moved ? order.indexOf(moved.dataset.muiItemId) : null,
              order,
              origin,
            }
            this.writeOrder(order)
            this.el.dispatchEvent(new CustomEvent("mui:draggable-change", {bubbles: true, detail}))
            if (origin !== "local") return
            const event = this.el.dataset.muiReorderEvent
            const target = this.el.dataset.muiReorderTarget
            if (event && target) this.pushEventTo(target, event, detail)
            else if (event) this.pushEvent(event, detail)
            this.channel?.push("reorder", {order})
          }
          this.applyOrder = (order, origin = "remote") => {
            const items = this.items()
            const current = this.order()
            const byId = new Map(items.map(item => [item.dataset.muiItemId, item]))
            if (!Array.isArray(order) || order.length !== items.length || new Set(order).size !== items.length || order.some(id => !byId.has(id))) return
            if (current.every((id, index) => id === order[index])) return
            if (this.dragged) {
              this.pendingOrder = order
              return
            }
            const positions = this.positions()
            order.forEach(id => this.el.appendChild(byId.get(id)))
            this.animateFrom(positions)
            const movedId = order.find((id, index) => current[index] !== id)
            this.notify(byId.get(movedId), current.indexOf(movedId), origin)
          }
          this.moveTo = (item, index) => {
            const items = this.items()
            const previousIndex = items.indexOf(item)
            const remaining = items.filter(candidate => candidate !== item)
            const nextIndex = Math.max(0, Math.min(index, remaining.length))
            const positions = this.positions()
            this.el.insertBefore(item, remaining[nextIndex] || null)
            this.animateFrom(positions)
            this.notify(item, previousIndex, "local")
          }
          this.createPlaceholder = (item) => {
            const template = this.el.querySelector("[data-mui-draggable-placeholder-template]")
            const placeholder = template.content.firstElementChild.cloneNode(true)
            const rect = item.getBoundingClientRect()
            placeholder.style.height = `${rect.height}px`
            if (this.el.dataset.muiOrientation === "horizontal") placeholder.style.width = `${rect.width}px`
            return placeholder
          }
          this.movePlaceholder = (target, before) => {
            const reference = before ? target : target.nextSibling
            if (reference === this.placeholder || this.placeholder.nextSibling === reference) return
            const positions = this.positions()
            this.el.insertBefore(this.placeholder, reference)
            this.animateFrom(positions)
          }
          this.completeDrag = (commit) => {
            const item = this.dragged
            if (!item) return
            const handle = item.querySelector("[data-mui-draggable-handle]")
            const positions = this.positions()
            if (commit) this.el.insertBefore(item, this.placeholder)
            else this.el.insertBefore(item, this.originalNextSibling)
            item.style.display = this.originalDisplay
            delete item.dataset.muiDragging
            handle?.setAttribute("aria-grabbed", "false")
            this.placeholder?.remove()
            this.placeholder = null
            this.dragged = null
            this.animateFrom(positions)
            if (commit && this.motionEnabled()) {
              item.animate([{opacity: 0, transform: "scale(0.98)"}, {opacity: 1, transform: "scale(1)"}], {
                duration: this.duration(),
                easing: this.easing,
              })
            }
            if (commit) this.notify(item, this.previousIndex, "local")
            if (this.pendingOrder) {
              const order = this.pendingOrder
              this.pendingOrder = null
              this.applyOrder(order)
            }
          }
          this.onDragStart = (event) => {
            const handle = event.target.closest("[data-mui-draggable-handle]")
            const item = handle?.closest("[data-mui-draggable-item]")
            if (!item || this.el.dataset.muiDisabled === "true" || item.dataset.muiDisabled === "true") {
              event.preventDefault()
              return
            }
            this.dragged = item
            this.previousIndex = this.items().indexOf(item)
            this.originalNextSibling = item.nextSibling
            this.originalDisplay = item.style.display
            this.placeholder = this.createPlaceholder(item)
            this.el.insertBefore(this.placeholder, item.nextSibling)
            item.dataset.muiDragging = "true"
            handle.setAttribute("aria-grabbed", "true")
            event.dataTransfer.effectAllowed = "move"
            event.dataTransfer.setData("text/plain", item.dataset.muiItemId)
            requestAnimationFrame(() => {
              if (this.dragged === item) item.style.display = "none"
            })
          }
          this.onDragOver = (event) => {
            const target = event.target.closest("[data-mui-draggable-item]")
            if (!this.dragged || !target || target === this.dragged || !this.el.contains(target)) return
            event.preventDefault()
            const rect = target.getBoundingClientRect()
            const horizontal = this.el.dataset.muiOrientation === "horizontal"
            const before = horizontal ? event.clientX < rect.left + rect.width / 2 : event.clientY < rect.top + rect.height / 2
            this.movePlaceholder(target, before)
          }
          this.onDrop = (event) => {
            if (!this.dragged || !this.placeholder) return
            event.preventDefault()
            this.completeDrag(true)
          }
          this.onDragEnd = () => this.completeDrag(false)
          this.onKeyDown = (event) => {
            const handle = event.target.closest("[data-mui-draggable-handle]")
            const item = handle?.closest("[data-mui-draggable-item]")
            if (!item || item.dataset.muiDisabled === "true") return
            if (event.key === " " || event.key === "Enter") {
              event.preventDefault()
              const grabbed = handle.getAttribute("aria-grabbed") !== "true"
              this.keyboardItem = grabbed ? item : null
              handle.setAttribute("aria-grabbed", String(grabbed))
              return
            }
            if (this.keyboardItem !== item) return
            const items = this.items()
            const index = items.indexOf(item)
            const previousKey = this.el.dataset.muiOrientation === "horizontal" ? "ArrowLeft" : "ArrowUp"
            const nextKey = this.el.dataset.muiOrientation === "horizontal" ? "ArrowRight" : "ArrowDown"
            let nextIndex = null
            if (event.key === previousKey) nextIndex = index - 1
            if (event.key === nextKey) nextIndex = index + 1
            if (event.key === "Home") nextIndex = 0
            if (event.key === "End") nextIndex = items.length - 1
            if (event.key === "Escape") {
              this.keyboardItem = null
              handle.setAttribute("aria-grabbed", "false")
            }
            if (nextIndex !== null) {
              event.preventDefault()
              this.moveTo(item, nextIndex)
              handle.focus()
            }
          }
          this.updateStatus = (status) => {
            this.el.dataset.muiRealtimeStatus = status
            document.querySelectorAll(`[data-mui-draggable-status-for="${CSS.escape(this.el.id)}"]`).forEach(element => {
              element.textContent = status
            })
          }
          this.connectRealtime = () => {
            const name = this.el.dataset.muiDocument
            if (!name) return
            const path = this.el.dataset.muiCollaborationSocket
            const connection = acquireSocket(this.liveSocket, path)
            this.releaseSocket = connection.release
            this.channel = connection.socket.channel(`mui_draggable:${name}`, {order: this.order()})
            this.channel.on("order", ({order}) => this.applyOrder(order))
            this.channel.onError(() => this.updateStatus("disconnected"))
            this.channel.onClose(() => this.updateStatus("disconnected"))
            this.updateStatus("connecting")
            this.channel.join()
              .receive("ok", ({order}) => {
                this.applyOrder(order)
                this.updateStatus("connected")
              })
              .receive("error", () => this.updateStatus("error"))
              .receive("timeout", () => this.updateStatus("disconnected"))
          }

          this.el.addEventListener("dragstart", this.onDragStart)
          this.el.addEventListener("dragover", this.onDragOver)
          this.el.addEventListener("drop", this.onDrop)
          this.el.addEventListener("dragend", this.onDragEnd)
          this.el.addEventListener("keydown", this.onKeyDown)
          this.connectRealtime()
        },
        destroyed() {
          this.el.removeEventListener("dragstart", this.onDragStart)
          this.el.removeEventListener("dragover", this.onDragOver)
          this.el.removeEventListener("drop", this.onDrop)
          this.el.removeEventListener("dragend", this.onDragEnd)
          this.el.removeEventListener("keydown", this.onKeyDown)
          this.channel?.leave()
          this.releaseSocket?.()
        },
      }
    </script>
    """
  end
end
