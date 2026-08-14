defmodule MatriarchUI.Toast do
  @moduledoc """
  Sonner-style toast notifications. Mount one `<.toaster>` near the root of
  your layout, then author each toast as a `<.toast>` — its body is kept in
  an inert `<template>` until triggered, so it can hold anything (title,
  description, buttons, custom markup) with full LiveView bindings intact.

      <.toaster id="toaster" />

      <.button phx-click={MatriarchUI.Toast.show_toast("saved")}>Save</.button>

      <.toast id="saved" variant="success">
        <.toast_title>Changes saved</.toast_title>
        <.toast_description>Your profile has been updated.</.toast_description>
      </.toast>

  Each toast picks its own corner or edge via `position`, so unrelated
  notifications can stack in different places on the same page. For
  server-driven notifications, stream `<.toast auto_show>` instances into the
  page (one per event) — `auto_show` triggers the toast itself the moment its
  template mounts, no `show/1` call needed. A dismissed toast (by timeout,
  close button, or `dismiss/1`) dispatches a bubbling `mui:toast:dismissed`
  `{id}` event on `document`, so a stream-backed toast can be pruned with
  `stream_delete` in response.
  """
  use Phoenix.Component
  alias MatriarchUI.CN
  alias Phoenix.LiveView.JS
  import MatriarchUI.Icon

  @positions ~w(top-left top-center top-right bottom-left bottom-center bottom-right)

  attr :id, :string, default: "toaster"
  attr :class, :string, default: nil

  def toaster(assigns) do
    assigns = assign(assigns, :positions, @positions)

    ~H"""
    <div id={@id} data-mui data-mui-toaster phx-hook=".MUIToaster" class={CN.cn([@class])}>
      <div
        :for={position <- @positions}
        data-mui-toast-region={position}
        class={region_class(position)}
      />
    </div>
    """
  end

  attr :id, :string, required: true
  attr :position, :string, default: "bottom-right", values: @positions

  attr :variant, :string, default: "default", values: ~w(default info success warning danger)

  attr :duration, :integer,
    default: 5000,
    doc: "auto-dismiss delay in ms; 0 keeps the toast until dismissed"

  attr :dismissible, :boolean, default: true

  attr :auto_show, :boolean,
    default: false,
    doc: "shows itself as soon as it mounts, for server-streamed toasts"

  attr :class, :string, default: nil
  attr :rest, :global
  slot :icon
  slot :inner_block, required: true

  def toast(assigns) do
    ~H"""
    <template
      id={@id}
      data-mui-toast-template
      data-mui-toast-position={@position}
      data-mui-toast-duration={@duration}
      phx-hook={@auto_show && ".MUIToastAuto"}
    >
      <div
        data-mui
        data-mui-toast
        role="status"
        aria-live="polite"
        class={
          CN.cn([
            "mui-toast pointer-events-auto relative flex w-[min(24rem,calc(100vw-2rem))] items-start gap-2.5",
            "rounded-mui-xl border border-mui-border bg-mui-surface p-3.5 text-sm shadow-mui-lg",
            @dismissible && "pr-8",
            @class
          ])
        }
        {@rest}
      >
        <span :if={@icon != [] or @variant != "default"} class={CN.cn(["mt-0.5 size-4 shrink-0", icon_classes(@variant)])}>
          <%= if @icon != [] do %>
            {render_slot(@icon)}
          <% else %>
            {default_icon(@variant)}
          <% end %>
        </span>
        <div class="min-w-0 flex-1">{render_slot(@inner_block)}</div>
        <button
          :if={@dismissible}
          type="button"
          data-mui-toast-close
          aria-label="Dismiss"
          class="absolute right-2.5 top-2.5 text-mui-subtle-foreground hover:text-mui-foreground"
        >
          <.icon name="x" class="size-3.5" />
        </button>
      </div>
    </template>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def toast_title(assigns) do
    ~H"""
    <p class={CN.cn(["font-medium text-mui-foreground", @class])}>{render_slot(@inner_block)}</p>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def toast_description(assigns) do
    ~H"""
    <p class={CN.cn(["mt-0.5 text-mui-muted-foreground", @class])}>{render_slot(@inner_block)}</p>
    """
  end

  @doc "Shows the `<.toast id={id}>` matching this id."
  def show_toast(id), do: JS.dispatch("mui:toast:show", to: "##{id}")

  @doc "Dismisses a currently visible toast before its timer or the user would."
  def dismiss_toast(id), do: JS.dispatch("mui:toast:dismiss", to: "##{id}")

  defp region_class(position) do
    CN.cn([
      "pointer-events-none fixed z-50 flex flex-col gap-2 p-4 sm:p-6",
      position_class(position)
    ])
  end

  defp position_class("top-left"), do: "left-0 top-0 items-start"
  defp position_class("top-center"), do: "inset-x-0 top-0 items-center"
  defp position_class("top-right"), do: "right-0 top-0 items-end"
  defp position_class("bottom-left"), do: "bottom-0 left-0 items-start"
  defp position_class("bottom-center"), do: "inset-x-0 bottom-0 items-center"
  defp position_class("bottom-right"), do: "bottom-0 right-0 items-end"

  defp icon_classes("default"), do: "text-mui-foreground"
  defp icon_classes("info"), do: "text-mui-accent"
  defp icon_classes("success"), do: "text-mui-success"
  defp icon_classes("warning"), do: "text-mui-warning"
  defp icon_classes("danger"), do: "text-mui-danger"

  defp default_icon(variant) do
    assigns = %{variant: variant}

    ~H"""
    <.icon :if={@variant == "info"} name="info" />
    <.icon :if={@variant == "success"} name="check-circle" />
    <.icon :if={@variant == "warning"} name="warning" />
    <.icon :if={@variant == "danger"} name="warning-circle" />
    """
  end

  attr :rest, :global

  def hook(assigns) do
    ~H"""
    <script :type={Phoenix.LiveView.ColocatedHook} name=".MUIToastAuto">
      export default {
        mounted() {
          this.el.dispatchEvent(new CustomEvent("mui:toast:show", { bubbles: true }))
        }
      }
    </script>
    <script :type={Phoenix.LiveView.ColocatedHook} name=".MUIToaster">
      export default {
        mounted() {
          const root = this.el
          const regions = new Map(
            Array.from(root.querySelectorAll("[data-mui-toast-region]")).map((region) => [
              region.dataset.muiToastRegion,
              region,
            ])
          )
          const easing =
            getComputedStyle(document.documentElement).getPropertyValue("--ease-mui-out").trim() ||
            "cubic-bezier(0.4, 0.36, 0, 1)"
          const reducedMotion = () => matchMedia("(prefers-reduced-motion: reduce)").matches
          const cardsIn = (region) => Array.from(region.children)
          const positionsOf = (region) => new Map(cardsIn(region).map((card) => [card, card.getBoundingClientRect()]))

          const reflow = (region, previous) => {
            if (reducedMotion()) return
            cardsIn(region).forEach((card) => {
              const before = previous.get(card)
              if (!before) return
              const after = card.getBoundingClientRect()
              const y = before.top - after.top
              if (Math.abs(y) < 0.5) return
              card.animate([{ transform: `translateY(${y}px)` }, { transform: "translate(0, 0)" }], {
                duration: 240,
                easing,
              })
            })
          }

          const enter = (card, position) => {
            if (reducedMotion()) return
            const offset = position.startsWith("top-") ? -16 : 16
            card.animate(
              [
                { opacity: 0, transform: `translateY(${offset}px) scale(0.96)` },
                { opacity: 1, transform: "translate(0, 0) scale(1)" },
              ],
              { duration: 240, easing },
            )
          }

          this.timers = new Map()

          const clearTimer = (id) => {
            clearTimeout(this.timers.get(id))
            this.timers.delete(id)
          }

          const scheduleDismiss = (card, region, duration) => {
            const id = card.dataset.muiToastFor
            clearTimer(id)
            if (!duration || duration <= 0) return
            this.timers.set(
              id,
              setTimeout(() => dismiss(card, region), duration),
            )
          }

          const dismiss = (card, region) => {
            const id = card.dataset.muiToastFor
            clearTimer(id)

            const finish = () => {
              const before = positionsOf(region)
              card.remove()
              reflow(region, before)
              document.dispatchEvent(new CustomEvent("mui:toast:dismissed", { detail: { id } }))
            }

            if (reducedMotion()) {
              finish()
              return
            }

            card.style.pointerEvents = "none"
            card
              .animate([{ opacity: 1, transform: "scale(1)" }, { opacity: 0, transform: "scale(0.96)" }], {
                duration: 180,
                easing,
              })
              .finished.catch(() => {})
              .finally(finish)
          }

          const show = (template) => {
            const id = template.id
            const position = template.dataset.muiToastPosition || "bottom-right"
            const region = regions.get(position)
            if (!region) return

            const duration = Number(template.dataset.muiToastDuration)
            const existing = region.querySelector(`[data-mui-toast-for="${CSS.escape(id)}"]`)
            if (existing) {
              scheduleDismiss(existing, region, duration)
              return
            }

            const card = template.content.firstElementChild.cloneNode(true)
            card.dataset.muiToastFor = id

            const before = positionsOf(region)
            if (position.startsWith("top-")) region.prepend(card)
            else region.appendChild(card)
            reflow(region, before)
            enter(card, position)

            card.querySelector("[data-mui-toast-close]")?.addEventListener("click", () => dismiss(card, region))
            card.addEventListener("mouseenter", () => clearTimer(id))
            card.addEventListener("mouseleave", () => scheduleDismiss(card, region, duration))

            scheduleDismiss(card, region, duration)
          }

          this.onShow = (event) => show(event.target)
          this.onDismiss = (event) => {
            const template = event.target
            const region = regions.get(template.dataset.muiToastPosition)
            const card = region?.querySelector(`[data-mui-toast-for="${CSS.escape(template.id)}"]`)
            if (card) dismiss(card, region)
          }

          document.addEventListener("mui:toast:show", this.onShow)
          document.addEventListener("mui:toast:dismiss", this.onDismiss)
        },
        destroyed() {
          document.removeEventListener("mui:toast:show", this.onShow)
          document.removeEventListener("mui:toast:dismiss", this.onDismiss)
          this.timers.forEach((timer) => clearTimeout(timer))
        },
      }
    </script>
    """
  end
end
