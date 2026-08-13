defmodule MatriarchUI.Floating do
  @moduledoc """
  Ships the `MatriarchUI.Floating.MUIFloating` colocated hook used by every
  anchored component (Tooltip, Popover, DropdownMenu, Select, Combobox). A
  colocated hook name is always prefixed with its *declaring* module, so
  components that reference this hook from another module must use the fully
  qualified name rather than the `.MUIFloating` shorthand. A trigger element sets:

    * `phx-hook="MatriarchUI.Floating.MUIFloating"` and `aria-controls` pointing at the panel id
    * `data-mui-placement` — e.g. `"bottom-start"`, `"top"`, `"right-end"` (default `"bottom-start"`)
    * `data-mui-trigger` — `"click"` (default), `"hover"`, or `"focus"`
    * `data-mui-offset` — gap in px between trigger and panel (default `8`)
    * `data-mui-role` — `"menu"` or `"listbox"` enables arrow-key roving focus
    * `data-mui-value-target` — id of the hidden input a `"listbox"` writes its
      selected value into (Select only)

  The panel needs `data-mui-state="closed"` initially and CSS driven off that
  attribute (`visibility`/`opacity`, never `display:none`, so it stays
  measurable). Items inside a menu/listbox panel get closed on click via a
  `data-mui-close` attribute. A `"listbox"` option additionally reads
  `data-mui-value`/`data-mui-label` and writes them into the value target plus
  any `[data-mui-select-label]` element inside the trigger.
  """
  use Phoenix.Component

  @doc "Shared positioning/animation classes for a floating panel; add surface chrome on top."
  def panel_class do
    [
      "fixed z-50 invisible scale-95 opacity-0 pointer-events-none transition duration-100 ease-out",
      "data-[mui-state=open]:visible data-[mui-state=open]:scale-100 data-[mui-state=open]:opacity-100",
      "data-[mui-state=open]:pointer-events-auto"
    ]
  end

  attr :rest, :global

  def hook(assigns) do
    ~H"""
    <script :type={Phoenix.LiveView.ColocatedHook} name=".MUIFloating">
      const SIDES = ["top", "right", "bottom", "left"]
      const OPPOSITE = { top: "bottom", bottom: "top", left: "right", right: "left" }

      function coordsFor(placement, triggerRect, panelRect, offset) {
        const [side, align = "center"] = placement.split("-")
        let x, y

        if (side === "top") y = triggerRect.top - panelRect.height - offset
        if (side === "bottom") y = triggerRect.bottom + offset
        if (side === "left") x = triggerRect.left - panelRect.width - offset
        if (side === "right") x = triggerRect.right + offset

        if (side === "top" || side === "bottom") {
          if (align === "start") x = triggerRect.left
          else if (align === "end") x = triggerRect.right - panelRect.width
          else x = triggerRect.left + triggerRect.width / 2 - panelRect.width / 2
        } else {
          if (align === "start") y = triggerRect.top
          else if (align === "end") y = triggerRect.bottom - panelRect.height
          else y = triggerRect.top + triggerRect.height / 2 - panelRect.height / 2
        }

        return { x, y }
      }

      function fits(side, triggerRect, panelRect, offset, viewport) {
        if (side === "top") return triggerRect.top - panelRect.height - offset >= 0
        if (side === "bottom") return triggerRect.bottom + panelRect.height + offset <= viewport.height
        if (side === "left") return triggerRect.left - panelRect.width - offset >= 0
        return triggerRect.right + panelRect.width + offset <= viewport.width
      }

      function resolvePlacement(placement, triggerRect, panelRect, offset, viewport) {
        const [side] = placement.split("-")
        if (!SIDES.includes(side)) return placement
        if (fits(side, triggerRect, panelRect, offset, viewport)) return placement
        const altSide = OPPOSITE[side]
        if (fits(altSide, triggerRect, panelRect, offset, viewport)) return placement.replace(side, altSide)
        return placement
      }

      function shift(coords, panelRect, viewport, padding = 8) {
        return {
          x: Math.min(Math.max(coords.x, padding), viewport.width - panelRect.width - padding),
          y: Math.min(Math.max(coords.y, padding), viewport.height - panelRect.height - padding)
        }
      }

      function positionArrow(arrow, placement, triggerRect, panelRect, coords) {
        const [side] = placement.split("-")
        const size = arrow.offsetWidth
        if (side === "top" || side === "bottom") {
          const center = triggerRect.left + triggerRect.width / 2 - coords.x - size / 2
          arrow.style.left = `${Math.min(Math.max(center, 6), panelRect.width - size - 6)}px`
          arrow.style.top = ""
        } else {
          const center = triggerRect.top + triggerRect.height / 2 - coords.y - size / 2
          arrow.style.top = `${Math.min(Math.max(center, 6), panelRect.height - size - 6)}px`
          arrow.style.left = ""
        }
      }

      function computeAndApply(trigger, panel, placement, offset) {
        const viewport = { width: window.innerWidth, height: window.innerHeight }
        const triggerRect = trigger.getBoundingClientRect()
        const panelRect = panel.getBoundingClientRect()
        const resolved = resolvePlacement(placement, triggerRect, panelRect, offset, viewport)
        const coords = shift(coordsFor(resolved, triggerRect, panelRect, offset), panelRect, viewport)

        panel.style.left = `${coords.x}px`
        panel.style.top = `${coords.y}px`
        panel.dataset.muiPlacement = resolved

        const arrow = panel.querySelector("[data-mui-arrow]")
        if (arrow) positionArrow(arrow, resolved, triggerRect, panelRect, coords)
      }

      function autoUpdate(trigger, panel, callback) {
        window.addEventListener("scroll", callback, true)
        window.addEventListener("resize", callback, true)
        const ro = new ResizeObserver(callback)
        ro.observe(panel)
        ro.observe(trigger)
        return () => {
          window.removeEventListener("scroll", callback, true)
          window.removeEventListener("resize", callback, true)
          ro.disconnect()
        }
      }

      function focusItem(panel, delta) {
        const items = Array.from(panel.querySelectorAll('[role="option"], [role="menuitem"]'))
        if (items.length === 0) return
        const current = items.indexOf(document.activeElement)
        const next = current === -1 ? 0 : (current + delta + items.length) % items.length
        items[next].focus()
      }

      function selectOption(trigger, panel, option) {
        const target = document.getElementById(trigger.dataset.muiValueTarget)
        if (target) {
          target.value = option.dataset.muiValue
          target.dispatchEvent(new Event("input", { bubbles: true }))
          target.dispatchEvent(new Event("change", { bubbles: true }))
        }
        const label = trigger.querySelector("[data-mui-select-label]")
        if (label) label.textContent = option.dataset.muiLabel || option.textContent
        panel.querySelectorAll('[role="option"]').forEach((el) => {
          el.setAttribute("aria-selected", el === option ? "true" : "false")
        })
      }

      export default {
        mounted() {
          const trigger = this.el
          const panel = document.getElementById(trigger.getAttribute("aria-controls"))
          if (!panel) return

          const placement = trigger.dataset.muiPlacement || "bottom-start"
          const offset = parseInt(trigger.dataset.muiOffset || "8", 10)
          const triggerMode = trigger.dataset.muiTrigger || "click"
          const role = trigger.dataset.muiRole
          let open = false
          let stopAutoUpdate = null

          const position = () => computeAndApply(trigger, panel, placement, offset)

          const onPointerDown = (event) => {
            if (panel.contains(event.target) || trigger.contains(event.target)) return
            hide()
          }

          const onKeydown = (event) => {
            if (event.key === "Escape") {
              hide()
              trigger.focus()
            } else if ((role === "menu" || role === "listbox") && event.key === "ArrowDown") {
              event.preventDefault()
              focusItem(panel, 1)
            } else if ((role === "menu" || role === "listbox") && event.key === "ArrowUp") {
              event.preventDefault()
              focusItem(panel, -1)
            }
          }

          const show = () => {
            if (open) return
            open = true
            panel.dataset.muiState = "open"
            trigger.setAttribute("aria-expanded", "true")
            position()
            stopAutoUpdate = autoUpdate(trigger, panel, position)
            document.addEventListener("pointerdown", onPointerDown, true)
            document.addEventListener("keydown", onKeydown, true)
            if (role === "menu" || role === "listbox") requestAnimationFrame(() => focusItem(panel, 0))
          }

          const hide = () => {
            if (!open) return
            open = false
            panel.dataset.muiState = "closed"
            trigger.setAttribute("aria-expanded", "false")
            if (stopAutoUpdate) stopAutoUpdate()
            document.removeEventListener("pointerdown", onPointerDown, true)
            document.removeEventListener("keydown", onKeydown, true)
          }

          if (triggerMode === "click") {
            trigger.addEventListener("click", () => (open ? hide() : show()))
          } else {
            const onEnter = () => show()
            const onLeave = () => hide()
            trigger.addEventListener("mouseenter", onEnter)
            trigger.addEventListener("mouseleave", onLeave)
            trigger.addEventListener("focus", onEnter)
            trigger.addEventListener("blur", onLeave)
            panel.addEventListener("mouseenter", onEnter)
            panel.addEventListener("mouseleave", onLeave)
          }

          panel.addEventListener("click", (event) => {
            const option = event.target.closest("[data-mui-value]")
            if (option && role === "listbox") selectOption(trigger, panel, option)
            if (event.target.closest("[data-mui-close]")) hide()
          })

          this.muiHide = hide
        },
        destroyed() {
          if (this.muiHide) this.muiHide()
        }
      }
    </script>
    """
  end
end
