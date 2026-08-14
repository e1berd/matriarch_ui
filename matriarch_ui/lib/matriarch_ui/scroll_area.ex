defmodule MatriarchUI.ScrollArea do
  @moduledoc "Overflow viewport with draggable custom scrollbars for one or both axes."
  use Phoenix.Component
  alias MatriarchUI.CN

  attr :id, :string, required: true
  attr :orientation, :string, default: "vertical", values: ~w(vertical horizontal both)
  attr :class, :string, default: nil
  attr :viewport_class, :string, default: nil
  attr :content_class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def scroll_area(assigns) do
    ~H"""
    <div
      id={@id}
      data-mui
      data-mui-orientation={@orientation}
      phx-hook=".MUIScrollArea"
      class={CN.cn(["relative overflow-hidden", @class])}
      {@rest}
    >
      <div
        data-mui-scroll-viewport
        tabindex="0"
        class={CN.cn(["mui-scroll-area-viewport size-full overscroll-contain", viewport_classes(@orientation), @viewport_class])}
      >
        <div data-mui-scroll-content class={CN.cn(["min-w-full", @content_class])}>
          {render_slot(@inner_block)}
        </div>
      </div>

      <div
        :if={@orientation in ~w(vertical both)}
        data-mui-scrollbar="vertical"
        data-active="false"
        class="absolute inset-y-2 right-2 z-10 w-1 rounded-mui-full bg-mui-scrollbar-track opacity-0 transition-opacity duration-150 before:absolute before:-inset-x-2 before:inset-y-0 before:content-[''] data-[active=true]:pointer-events-auto data-[active=true]:opacity-100"
      >
        <div
          data-mui-scroll-thumb
          class="absolute inset-x-0 top-0 min-h-5 touch-none rounded-mui-full bg-mui-scrollbar-thumb transition-colors hover:bg-mui-scrollbar-thumb-hover"
        />
      </div>

      <div
        :if={@orientation in ~w(horizontal both)}
        data-mui-scrollbar="horizontal"
        data-active="false"
        class="absolute inset-x-2 bottom-2 z-10 h-1 rounded-mui-full bg-mui-scrollbar-track opacity-0 transition-opacity duration-150 before:absolute before:inset-x-0 before:-inset-y-2 before:content-[''] data-[active=true]:pointer-events-auto data-[active=true]:opacity-100"
      >
        <div
          data-mui-scroll-thumb
          class="absolute inset-y-0 left-0 min-w-5 touch-none rounded-mui-full bg-mui-scrollbar-thumb transition-colors hover:bg-mui-scrollbar-thumb-hover"
        />
      </div>
    </div>

    <script :type={Phoenix.LiveView.ColocatedHook} name=".MUIScrollArea">
      function measurements(viewport, track, orientation) {
        const vertical = orientation === "vertical"
        const viewportSize = vertical ? viewport.clientHeight : viewport.clientWidth
        const contentSize = vertical ? viewport.scrollHeight : viewport.scrollWidth
        const trackSize = vertical ? track.clientHeight : track.clientWidth
        const scrollPosition = vertical ? viewport.scrollTop : viewport.scrollLeft
        const maxScroll = Math.max(contentSize - viewportSize, 0)
        const thumbSize = Math.max(20, trackSize * viewportSize / contentSize)
        const maxThumbOffset = Math.max(trackSize - thumbSize, 0)
        const thumbOffset = maxScroll === 0 ? 0 : scrollPosition / maxScroll * maxThumbOffset

        return { vertical, viewportSize, contentSize, trackSize, maxScroll, thumbSize, maxThumbOffset, thumbOffset }
      }

      function updateScrollbar(viewport, track) {
        const orientation = track.dataset.muiScrollbar
        const thumb = track.querySelector("[data-mui-scroll-thumb]")
        const vertical = orientation === "vertical"
        const viewportSize = vertical ? viewport.clientHeight : viewport.clientWidth
        const contentSize = vertical ? viewport.scrollHeight : viewport.scrollWidth
        const hasOverflow = contentSize > viewportSize + 1

        track.hidden = !hasOverflow
        if (!hasOverflow) return

        const state = measurements(viewport, track, orientation)

        if (state.vertical) {
          thumb.style.height = `${state.thumbSize}px`
          thumb.style.transform = `translateY(${state.thumbOffset}px)`
        } else {
          thumb.style.width = `${state.thumbSize}px`
          thumb.style.transform = `translateX(${state.thumbOffset}px)`
        }
      }

      function setScrollFromPointer(viewport, track, orientation, pointerPosition, centered) {
        const state = measurements(viewport, track, orientation)
        const trackRect = track.getBoundingClientRect()
        const trackStart = state.vertical ? trackRect.top : trackRect.left
        const thumbOffset = centered ? pointerPosition - trackStart - state.thumbSize / 2 : pointerPosition
        const ratio = state.maxThumbOffset === 0 ? 0 : Math.min(Math.max(thumbOffset, 0), state.maxThumbOffset) / state.maxThumbOffset

        if (state.vertical) viewport.scrollTop = ratio * state.maxScroll
        else viewport.scrollLeft = ratio * state.maxScroll
      }

      export default {
        mounted() {
          const root = this.el
          const viewport = root.querySelector("[data-mui-scroll-viewport]")
          const content = root.querySelector("[data-mui-scroll-content]")
          const tracks = Array.from(root.querySelectorAll("[data-mui-scrollbar]"))
          const cleanups = []
          let scrollTimer

          const update = () => tracks.forEach((track) => updateScrollbar(viewport, track))
          const setActive = (active) => tracks.forEach((track) => track.dataset.active = String(active))
          const onScroll = () => {
            setActive(true)
            update()
            clearTimeout(scrollTimer)
            scrollTimer = setTimeout(() => setActive(root.matches(":hover")), 700)
          }
          const onPointerEnter = () => setActive(true)
          const onPointerLeave = () => setActive(false)

          viewport.addEventListener("scroll", onScroll, { passive: true })
          root.addEventListener("pointerenter", onPointerEnter)
          root.addEventListener("pointerleave", onPointerLeave)
          cleanups.push(() => viewport.removeEventListener("scroll", onScroll))
          cleanups.push(() => root.removeEventListener("pointerenter", onPointerEnter))
          cleanups.push(() => root.removeEventListener("pointerleave", onPointerLeave))

          tracks.forEach((track) => {
            const orientation = track.dataset.muiScrollbar
            const thumb = track.querySelector("[data-mui-scroll-thumb]")
            let dragStart

            const onTrackPointerDown = (event) => {
              if (event.target === thumb) return
              const pointerPosition = orientation === "vertical" ? event.clientY : event.clientX
              setScrollFromPointer(viewport, track, orientation, pointerPosition, true)
            }
            const onThumbPointerDown = (event) => {
              event.preventDefault()
              const state = measurements(viewport, track, orientation)
              dragStart = {
                pointer: state.vertical ? event.clientY : event.clientX,
                offset: state.thumbOffset
              }
              thumb.setPointerCapture(event.pointerId)
              setActive(true)
            }
            const onThumbPointerMove = (event) => {
              if (!dragStart || !thumb.hasPointerCapture(event.pointerId)) return
              const pointer = orientation === "vertical" ? event.clientY : event.clientX
              setScrollFromPointer(viewport, track, orientation, dragStart.offset + pointer - dragStart.pointer, false)
            }
            const onThumbPointerUp = (event) => {
              if (thumb.hasPointerCapture(event.pointerId)) thumb.releasePointerCapture(event.pointerId)
              dragStart = null
              setActive(root.matches(":hover"))
            }

            track.addEventListener("pointerdown", onTrackPointerDown)
            thumb.addEventListener("pointerdown", onThumbPointerDown)
            thumb.addEventListener("pointermove", onThumbPointerMove)
            thumb.addEventListener("pointerup", onThumbPointerUp)
            thumb.addEventListener("pointercancel", onThumbPointerUp)
            cleanups.push(() => track.removeEventListener("pointerdown", onTrackPointerDown))
            cleanups.push(() => thumb.removeEventListener("pointerdown", onThumbPointerDown))
            cleanups.push(() => thumb.removeEventListener("pointermove", onThumbPointerMove))
            cleanups.push(() => thumb.removeEventListener("pointerup", onThumbPointerUp))
            cleanups.push(() => thumb.removeEventListener("pointercancel", onThumbPointerUp))
          })

          const resizeObserver = new ResizeObserver(update)
          resizeObserver.observe(root)
          resizeObserver.observe(viewport)
          resizeObserver.observe(content)
          const mutationObserver = new MutationObserver(update)
          mutationObserver.observe(content, { childList: true, subtree: true, characterData: true })

          requestAnimationFrame(update)
          this.muiScrollAreaCleanup = () => {
            clearTimeout(scrollTimer)
            resizeObserver.disconnect()
            mutationObserver.disconnect()
            cleanups.forEach((cleanup) => cleanup())
          }
        },
        destroyed() {
          if (this.muiScrollAreaCleanup) this.muiScrollAreaCleanup()
        }
      }
    </script>
    """
  end

  defp viewport_classes("vertical"), do: "overflow-y-scroll overflow-x-hidden"
  defp viewport_classes("horizontal"), do: "overflow-x-scroll overflow-y-hidden"
  defp viewport_classes("both"), do: "overflow-scroll"
end
