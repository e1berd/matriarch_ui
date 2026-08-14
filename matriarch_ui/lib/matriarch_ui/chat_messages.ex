defmodule MatriarchUI.ChatMessages do
  @moduledoc "Virtualized message viewport with bidirectional LiveView events and anchored scrolling."
  use Phoenix.Component
  alias MatriarchUI.CN
  alias MatriarchUI.ScrollArea

  attr :id, :string, required: true
  attr :messages_limit, :integer, default: 64
  attr :messages_offset, :integer, default: 0
  attr :target_message_id, :string, default: nil
  attr :has_older, :boolean, default: false
  attr :has_newer, :boolean, default: false
  attr :load_older, :string, default: "chat:load-older"
  attr :load_newer, :string, default: "chat:load-newer"
  attr :loading, :boolean, default: false
  attr :label, :string, default: "Messages"
  attr :class, :string, default: nil
  attr :viewport_class, :string, default: nil
  attr :content_class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def chat_messages(assigns) do
    ~H"""
    <ScrollArea.scroll_area
      id={@id}
      class={CN.cn(["min-h-0 flex-1", @class])}
      viewport_class={CN.cn(["bg-mui-card-muted/20 mui-dark:bg-mui-card-muted/30", @viewport_class])}
      content_class={CN.cn(["min-h-full", @content_class])}
      {@rest}
    >
      <div
        id={"#{@id}-window"}
        data-mui-chat-window
        class="flex min-h-full flex-col"
      >
        <div data-mui-chat-edge="older" class="h-px shrink-0" />
        <div
          id={"#{@id}-stream"}
          phx-update="stream"
          phx-hook=".MUIChatMessages"
          data-messages-limit={@messages_limit}
          data-messages-offset={@messages_offset}
          data-target-message-id={@target_message_id}
          data-has-older={to_string(@has_older)}
          data-has-newer={to_string(@has_newer)}
          data-load-older={@load_older}
          data-load-newer={@load_newer}
          role="log"
          aria-label={@label}
          aria-live="polite"
          aria-relevant="additions"
          aria-busy={to_string(@loading)}
          class="flex flex-1 flex-col justify-end gap-2.5 px-3.5 py-4 [overflow-anchor:none]"
        >
          {render_slot(@inner_block)}
        </div>
        <div data-mui-chat-edge="newer" class="h-px shrink-0" />
      </div>
    </ScrollArea.scroll_area>

    <script :type={Phoenix.LiveView.ColocatedHook} name=".MUIChatMessages">
      const messageSelector = "[data-mui-chat-message]"

      function messageElements(root) {
        return Array.from(root.querySelectorAll(messageSelector))
      }

      function reducedMotion() {
        return window.matchMedia("(prefers-reduced-motion: reduce)").matches
      }

      export default {
        mounted() {
          this.viewport = this.el.closest("[data-mui-scroll-content]")?.parentElement
          this.lastTargetId = null
          this.loadingOlder = false
          this.loadingNewer = false
          this.suppressScroll = true
          this.patchSnapshot = null

          if (!this.viewport) return

          this.animationObserver = new IntersectionObserver(
            (entries) => entries.forEach((entry) => {
              if (entry.isIntersecting) this.startMessageAnimation(entry.target)
            }),
            {root: this.viewport, rootMargin: "16px 0px", threshold: 0.05}
          )

          this.lastScrollTop = this.viewport.scrollTop
          const messages = messageElements(this.el)
          this.knownIds = new Set(messages.map((message) => message.dataset.messageId))
          this.lastKnownId = messages.at(-1)?.dataset.messageId
          this.previousOffset = Number(this.el.dataset.messagesOffset)
          this.wasNearBottom = true
          this.onScroll = () => {
            cancelAnimationFrame(this.scrollFrame)
            this.scrollFrame = requestAnimationFrame(() => this.handleScroll())
          }
          this.onWheel = (event) => this.handleBoundaryIntent(event.deltaY)
          this.onTouchStart = (event) => this.touchY = event.touches[0]?.clientY
          this.onTouchMove = (event) => {
            const nextY = event.touches[0]?.clientY
            if (this.touchY == null || nextY == null) return
            this.handleBoundaryIntent(this.touchY - nextY)
            this.touchY = nextY
          }
          this.viewport.addEventListener("scroll", this.onScroll, {passive: true})
          this.viewport.addEventListener("wheel", this.onWheel, {passive: true})
          this.viewport.addEventListener("touchstart", this.onTouchStart, {passive: true})
          this.viewport.addEventListener("touchmove", this.onTouchMove, {passive: true})
          this.scrollToInitialPosition()
        },

        beforeUpdate() {
          if (!this.viewport) return
          const bottomDistance = this.viewport.scrollHeight - this.viewport.scrollTop - this.viewport.clientHeight
          this.patchSnapshot ||= {
            scrollTop: this.viewport.scrollTop,
            bottomDistance,
            nearBottom: bottomDistance < 48
          }
          this.wasNearBottom = this.patchSnapshot.nearBottom
        },

        updated() {
          if (!this.viewport) return
          cancelAnimationFrame(this.updateFrame)
          this.updateFrame = requestAnimationFrame(() => this.reconcileUpdate())
        },

        reconcileUpdate() {
          const messages = messageElements(this.el)
          const oldOffset = this.pendingWindow?.offset ?? this.previousOffset

          const nextOffset = Number(this.el.dataset.messagesOffset)
          const targetId = this.el.dataset.targetMessageId
          const windowShifted = nextOffset !== oldOffset
          const direction = nextOffset < oldOffset ? "older" : "newer"
          const newMessages = messages.filter((message) => !this.knownIds.has(message.dataset.messageId))
          const previousLastIndex = messages.findIndex((message) => message.dataset.messageId === this.lastKnownId)
          const tailMessages = previousLastIndex < 0 ? [] : messages.slice(previousLastIndex + 1)

          this.loadingOlder = false
          this.loadingNewer = false

          if (windowShifted) {
            this.restoreAnchor(this.pendingWindow)
            this.animateMessages(newMessages, direction)
          } else {
            this.animateMessages(newMessages, "tail")
          }

          const ownMessageLoaded = newMessages.some((message) => message.dataset.muiSide === "outgoing")
          const appendedAtTail = !windowShifted && tailMessages.length > 0 && this.wasNearBottom
          const reachedLatestWindow = windowShifted && direction === "newer" && this.el.dataset.hasNewer !== "true"
          const followsTail = (appendedAtTail || ownMessageLoaded || reachedLatestWindow) && !targetId
          const targetChanged = targetId && targetId !== this.lastTargetId

          this.knownIds = new Set(messages.map((message) => message.dataset.messageId))
          this.lastKnownId = messages.at(-1)?.dataset.messageId
          this.previousOffset = nextOffset
          this.pendingWindow = null

          if (followsTail) {
            this.restorePatchPosition(this.patchSnapshot)
            this.scrollToBottom("smooth")
          }

          if (targetChanged) {
            this.scrollToBottom("auto")
            requestAnimationFrame(() => this.focusTarget(targetId))
          }

          if (!followsTail && !targetChanged) this.releaseScrollSuppression()
          this.patchSnapshot = null
        },

        destroyed() {
          cancelAnimationFrame(this.scrollFrame)
          cancelAnimationFrame(this.updateFrame)
          clearTimeout(this.scrollTimer)
          this.animationObserver?.disconnect()
          this.viewport?.removeEventListener("scroll", this.onScroll)
          this.viewport?.removeEventListener("wheel", this.onWheel)
          this.viewport?.removeEventListener("touchstart", this.onTouchStart)
          this.viewport?.removeEventListener("touchmove", this.onTouchMove)
        },

        handleScroll() {
          const scrollTop = this.viewport.scrollTop
          const delta = scrollTop - this.lastScrollTop
          const bottomDistance = this.viewport.scrollHeight - scrollTop - this.viewport.clientHeight
          this.lastScrollTop = scrollTop

          if (this.suppressScroll || Math.abs(delta) < 0.5) return
          if (delta < 0 && scrollTop < 120) this.requestOlder()
          if (delta > 0 && bottomDistance < 120) this.requestNewer()
        },

        handleBoundaryIntent(delta) {
          if (this.suppressScroll || Math.abs(delta) < 0.5) return

          const bottomDistance = this.viewport.scrollHeight - this.viewport.scrollTop - this.viewport.clientHeight
          if (delta < 0 && this.viewport.scrollTop < 120) this.requestOlder()
          if (delta > 0 && bottomDistance < 120) this.requestNewer()
        },

        requestOlder() {
          if (this.el.dataset.hasOlder !== "true" || this.loadingOlder) return
          this.loadingOlder = true
          this.pushWindowEvent(this.el.dataset.loadOlder, "older")
        },

        requestNewer() {
          if (this.el.dataset.hasNewer !== "true" || this.loadingNewer) return
          this.loadingNewer = true
          this.pushWindowEvent(this.el.dataset.loadNewer, "newer")
        },

        pushWindowEvent(event, direction) {
          const messages = messageElements(this.el)
          this.pendingWindow = this.snapshotWindow(direction)
          this.suppressScrolling(0)

          this.pushEvent(event, {
            direction,
            limit: Number(this.el.dataset.messagesLimit),
            offset: Number(this.el.dataset.messagesOffset),
            first_message_id: messages[0]?.dataset.messageId,
            last_message_id: messages.at(-1)?.dataset.messageId
          })
        },

        scrollToInitialPosition() {
          requestAnimationFrame(() => {
            this.scrollToBottom("auto")
            const targetId = this.el.dataset.targetMessageId
            if (targetId) requestAnimationFrame(() => this.focusTarget(targetId))
            else this.releaseScrollSuppression()
          })
        },

        scrollToBottom(behavior) {
          this.suppressScrolling(behavior === "smooth" ? 1_200 : 0)
          this.viewport.scrollTo({top: this.viewport.scrollHeight, behavior: reducedMotion() ? "auto" : behavior})
        },

        focusTarget(messageId) {
          const target = messageElements(this.el).find((message) => message.dataset.messageId === messageId)
          if (!target || this.lastTargetId === messageId) return

          this.lastTargetId = messageId
          this.suppressScrolling(550)
          target.focus({preventScroll: true})
          target.scrollIntoView({behavior: reducedMotion() ? "auto" : "smooth", block: "center"})
        },

        snapshotWindow(direction) {
          const viewportRect = this.viewport.getBoundingClientRect()
          const anchor = messageElements(this.el).find((message) => message.getBoundingClientRect().bottom > viewportRect.top)

          return {
            direction,
            offset: Number(this.el.dataset.messagesOffset),
            anchorId: anchor?.dataset.messageId,
            anchorTop: anchor ? anchor.getBoundingClientRect().top - viewportRect.top : 0
          }
        },

        restoreAnchor(state) {
          const anchor = messageElements(this.el).find((message) => message.dataset.messageId === state?.anchorId)
          this.suppressScrolling(0)

          if (!anchor) {
            const maximum = Math.max(this.viewport.scrollHeight - this.viewport.clientHeight, 0)
            this.viewport.scrollTop = maximum * 0.5
            return
          }

          const viewportTop = this.viewport.getBoundingClientRect().top
          this.viewport.scrollTop += anchor.getBoundingClientRect().top - viewportTop - state.anchorTop
        },

        restorePatchPosition(state) {
          if (!state) return
          const maximum = Math.max(this.viewport.scrollHeight - this.viewport.clientHeight, 0)
          this.suppressScrolling(0)
          this.viewport.scrollTop = Math.min(state.scrollTop, maximum)
        },

        animateMessages(messages, direction) {
          if (reducedMotion()) return

          messages.forEach((message, index) => {
            message.dataset.muiEnterPending = direction
            message.style.setProperty("--mui-chat-enter-delay", `${Math.min(index, 8) * 18}ms`)
            this.animationObserver?.observe(message)
          })
        },

        startMessageAnimation(message) {
          const direction = message.dataset.muiEnterPending
          if (!direction) return

          this.animationObserver?.unobserve(message)
          delete message.dataset.muiEnterPending
          message.dataset.muiEnter = direction
          message.addEventListener("animationend", () => {
            delete message.dataset.muiEnter
            message.style.removeProperty("--mui-chat-enter-delay")
          }, {once: true})
        },

        suppressScrolling(duration) {
          this.suppressScroll = true
          clearTimeout(this.scrollTimer)

          if (duration > 0 && !reducedMotion()) {
            this.scrollTimer = setTimeout(() => this.releaseScrollSuppression(), duration)
          }
        },

        releaseScrollSuppression() {
          requestAnimationFrame(() => requestAnimationFrame(() => {
            this.lastScrollTop = this.viewport.scrollTop
            this.suppressScroll = false
          }))
        }
      }
    </script>
    """
  end
end
