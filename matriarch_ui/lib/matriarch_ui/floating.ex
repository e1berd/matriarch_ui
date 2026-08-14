defmodule MatriarchUI.Floating do
  @moduledoc """
  Ships the `MatriarchUI.Floating.MUIFloating` colocated hook used by every
  anchored component (Tooltip, Popover, DropdownMenu, Select, Autocomplete). A
  colocated hook name is always prefixed with its *declaring* module, so
  components that reference this hook from another module must use the fully
  qualified name rather than the `.MUIFloating` shorthand. A trigger element sets:

    * `phx-hook="MatriarchUI.Floating.MUIFloating"` and `aria-controls` pointing at the panel id
    * `data-mui-placement` — e.g. `"bottom-start"`, `"top"`, `"right-end"`, or
      `"auto"` (default `"bottom-start"`). `"auto"` opens toward the viewport
      center — bottom if the trigger sits in the upper half of the screen,
      top if it sits in the lower half — then lets the fallback below take over.
    * `data-mui-trigger` — `"click"` (default), `"hover"`, or `"focus"`
    * `data-mui-offset` — gap in px between trigger and panel (default `8`)
    * `data-mui-axis` — `"both"` (default) lets the panel fall back to any of
      the 4 sides when the requested one has no room; `"vertical"` (Select)
      restricts fallback to top/bottom only, never left/right
    * `data-mui-role` — `"menu"` or `"listbox"` enables arrow-key roving focus
    * `data-mui-match-width` — `"true"` keeps the panel as wide as its trigger
    * `data-mui-persistent` — `"true"` keeps an open panel open when its trigger is clicked again
    * `data-mui-value-target` — id of the hidden input a `"listbox"` writes its
      selected value into (Select only)

  Whatever side is requested, if it doesn't fit in the viewport the panel
  falls back to the opposite side, then (unless `data-mui-axis="vertical"`)
  to whichever perpendicular side has the most room — it always ends up
  somewhere on-screen.

  The panel needs `data-mui-state="closed"` initially and CSS driven off that
  attribute (`visibility`/`opacity`, never `display:none`, so it stays
  measurable). Clicking a `"listbox"` option closes the panel and writes the
  option's `data-mui-value`/`data-mui-label` into the `data-mui-value-target`
  hidden input (Select) or, when the trigger itself is an `<input>`
  (Autocomplete), directly into the trigger's own value. Items inside a
  menu/listbox panel also get closed on click via a `data-mui-close` attribute.

  A `MutationObserver` on the panel re-asserts `data-mui-state="open"` and
  repositions whenever its content changes while open — this keeps a listbox
  open across a LiveView-driven re-render of its options (e.g. Autocomplete
  filtering server-side on `phx-change`), since that re-render would otherwise
  overwrite the JS-set `data-mui-state` back to the template's static
  `"closed"`.
  """
  use Phoenix.Component

  @doc """
  Shared positioning/animation classes for a floating panel; add surface chrome
  on top. Uses the same `duration-150 ease-mui-out` scale+fade recipe as
  `MatriarchUI.Modal`, so every overlay in the app opens with an identical feel.
  """
  def panel_class do
    [
      "fixed z-50 invisible scale-95 opacity-0 pointer-events-none",
      "transition duration-150 ease-mui-out transition-discrete",
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

      function spaceFor(side, triggerRect, offset, viewport) {
        if (side === "top") return triggerRect.top - offset
        if (side === "bottom") return viewport.height - triggerRect.bottom - offset
        if (side === "left") return triggerRect.left - offset
        return viewport.width - triggerRect.right - offset
      }

      function sideFits(side, triggerRect, panelRect, offset, viewport) {
        const size = side === "top" || side === "bottom" ? panelRect.height : panelRect.width
        return spaceFor(side, triggerRect, offset, viewport) >= size
      }

      function autoSide(triggerRect, viewport) {
        return triggerRect.top + triggerRect.height / 2 > viewport.height / 2 ? "top" : "bottom"
      }

      function candidateSides(preferredSide, axis, triggerRect, offset, viewport) {
        if (axis === "vertical") return [preferredSide, OPPOSITE[preferredSide]]
        const perpendiculars = SIDES.filter((side) => side !== preferredSide && side !== OPPOSITE[preferredSide])
        perpendiculars.sort(
          (a, b) => spaceFor(b, triggerRect, offset, viewport) - spaceFor(a, triggerRect, offset, viewport)
        )
        return [preferredSide, OPPOSITE[preferredSide], ...perpendiculars]
      }

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

      function resolvePlacement(placement, triggerRect, panelRect, offset, viewport, axis) {
        const isAuto = placement === "auto"
        const preferredSide = isAuto ? autoSide(triggerRect, viewport) : placement.split("-")[0]
        if (!SIDES.includes(preferredSide)) return placement
        const align = isAuto ? "center" : placement.split("-")[1] || "center"

        const candidates = candidateSides(preferredSide, axis, triggerRect, offset, viewport)
        const bestSide =
          candidates.find((side) => sideFits(side, triggerRect, panelRect, offset, viewport)) ||
          candidates.reduce((best, side) =>
            spaceFor(side, triggerRect, offset, viewport) > spaceFor(best, triggerRect, offset, viewport)
              ? side
              : best
          )

        return align === "center" ? bestSide : `${bestSide}-${align}`
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

      function computeAndApply(trigger, panel, placement, offset, axis) {
        const viewport = { width: window.innerWidth, height: window.innerHeight }
        const triggerRect = trigger.getBoundingClientRect()
        if (trigger.dataset.muiMatchWidth === "true") panel.style.width = `${triggerRect.width}px`
        const panelRect = panel.getBoundingClientRect()
        const resolved = resolvePlacement(placement, triggerRect, panelRect, offset, viewport, axis)
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
        const items = Array.from(panel.querySelectorAll('[role="option"], [role="menuitem"]')).filter(
          (item) => !item.hidden && item.getAttribute("aria-disabled") !== "true"
        )
        if (items.length === 0) return
        const current = items.indexOf(document.activeElement)
        const next = current === -1 ? 0 : (current + delta + items.length) % items.length
        items[next].focus()
      }

      function selectOption(trigger, panel, option) {
        const label = option.dataset.muiLabel || option.textContent.trim()
        const multiple = trigger.dataset.muiMultiple === "true"

        if (trigger.tagName === "INPUT") {
          trigger.value = label
          trigger.dispatchEvent(new Event("input", { bubbles: true }))
          trigger.dispatchEvent(new Event("change", { bubbles: true }))
        }

        const target = document.getElementById(trigger.dataset.muiValueTarget)
        const labelEl = trigger.querySelector("[data-mui-select-label]")

        if (multiple) {
          const selected = option.getAttribute("aria-selected") !== "true"
          option.setAttribute("aria-selected", selected ? "true" : "false")

          if (target?.tagName === "SELECT") {
            const targetOption = Array.from(target.options).find(
              (item) => item.value === option.dataset.muiValue
            )
            if (targetOption) targetOption.selected = selected
            target.dispatchEvent(new Event("input", { bubbles: true }))
            target.dispatchEvent(new Event("change", { bubbles: true }))
          }

          const labels = Array.from(panel.querySelectorAll('[role="option"][aria-selected="true"]')).map(
            (item) => item.dataset.muiLabel || item.textContent.trim()
          )
          if (labelEl) labelEl.textContent = labels.join(", ") || trigger.dataset.muiPlaceholder || ""
          return
        }

        if (target) {
          target.value = option.dataset.muiValue
          target.dispatchEvent(new Event("input", { bubbles: true }))
          target.dispatchEvent(new Event("change", { bubbles: true }))
        }

        if (labelEl) labelEl.textContent = label

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
          const axis = trigger.dataset.muiAxis || "both"
          const triggerMode = trigger.dataset.muiTrigger || "click"
          const role = trigger.dataset.muiRole
          const persistent = trigger.dataset.muiPersistent === "true"
          let open = false
          let stopAutoUpdate = null

          const position = () => computeAndApply(trigger, panel, placement, offset, axis)
          const filterOptions = () => {
            if (role !== "listbox" || trigger.tagName !== "INPUT" || trigger.dataset.muiFilter !== "true") return
            const query = trigger.value.trim().toLocaleLowerCase()
            const options = Array.from(panel.querySelectorAll('[role="option"]'))
            let visibleCount = 0

            options.forEach((option) => {
              const label = (option.dataset.muiLabel || option.textContent).trim().toLocaleLowerCase()
              option.hidden = query !== "" && !label.includes(query)
              if (!option.hidden) visibleCount += 1
            })

            const empty = panel.querySelector("[data-mui-empty]")
            if (empty) empty.hidden = visibleCount !== 0
          }

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
            } else if (role === "listbox" && event.key === "Enter") {
              const option = document.activeElement.closest?.('[role="option"]')
              if (option && panel.contains(option)) {
                event.preventDefault()
                selectOption(trigger, panel, option)
                if (trigger.dataset.muiMultiple !== "true") hide()
              }
            }
          }

          const show = () => {
            if (open) return
            open = true
            filterOptions()
            panel.dataset.muiState = "open"
            trigger.setAttribute("aria-expanded", "true")
            position()
            stopAutoUpdate = autoUpdate(trigger, panel, position)
            document.addEventListener("pointerdown", onPointerDown, true)
            document.addEventListener("keydown", onKeydown, true)
            if ((role === "menu" || role === "listbox") && trigger.tagName !== "INPUT") {
              requestAnimationFrame(() => focusItem(panel, 0))
            }
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
            trigger.addEventListener("click", () => (open ? (persistent ? show() : hide()) : show()))
          } else if (triggerMode === "focus") {
            trigger.addEventListener("focus", show)
            trigger.addEventListener("click", show)
            trigger.addEventListener("input", () => {
              filterOptions()
              show()
            })
            trigger.addEventListener("blur", () => {
              requestAnimationFrame(() => {
                if (!panel.contains(document.activeElement)) hide()
              })
            })
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
            if (option && role === "listbox") {
              selectOption(trigger, panel, option)
              if (trigger.dataset.muiMultiple !== "true") hide()
            }
            if (event.target.closest("[data-mui-close]")) hide()
          })

          const panelObserver = new MutationObserver(() => {
            if (!open) return
            if (panel.dataset.muiState !== "open") panel.dataset.muiState = "open"
            filterOptions()
            position()
          })
          panelObserver.observe(panel, {
            childList: true,
            subtree: true,
            attributes: true,
            attributeFilter: ["data-mui-state"]
          })

          this.muiHide = hide
          this.muiPanelObserver = panelObserver
        },
        destroyed() {
          if (this.muiHide) this.muiHide()
          if (this.muiPanelObserver) this.muiPanelObserver.disconnect()
        }
      }
    </script>
    """
  end
end
