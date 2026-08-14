defmodule MatriarchUI.Carousel do
  @moduledoc "Scroll-snap slideshow — prev/next buttons and dots, no JS layout math."
  use Phoenix.Component
  alias MatriarchUI.CN

  attr :id, :string, required: true
  attr :label, :string, default: "Carousel"
  attr :class, :string, default: nil
  slot :slide, required: true

  def carousel(assigns) do
    ~H"""
    <div
      id={@id}
      data-mui
      phx-hook=".MUICarousel"
      role="region"
      aria-roledescription="carousel"
      aria-label={@label}
      tabindex="0"
      class={CN.cn(["relative", @class])}
    >
      <div
        data-mui-track
        class="flex snap-x snap-mandatory overflow-x-auto motion-safe:scroll-smooth rounded-mui-lg [scrollbar-width:none] [&::-webkit-scrollbar]:hidden"
      >
        <div
          :for={{slide, index} <- Enum.with_index(@slide)}
          data-mui-slide={index}
          class="w-full shrink-0 snap-start"
        >
          {render_slot(slide)}
        </div>
      </div>

      <button
        type="button"
        data-mui-prev
        aria-label="Previous slide"
        class="absolute left-2 top-1/2 flex size-8 -translate-y-1/2 items-center justify-center rounded-mui-full border border-mui-border bg-mui-surface/90 text-mui-foreground shadow-mui-sm hover:bg-mui-surface-hover disabled:pointer-events-none disabled:opacity-40"
      >
        <svg class="size-4" viewBox="0 0 20 20" fill="none" aria-hidden="true">
          <path
            d="M12.5 5L7.5 10l5 5"
            stroke="currentColor"
            stroke-width="1.5"
            stroke-linecap="round"
            stroke-linejoin="round"
          />
        </svg>
      </button>
      <button
        type="button"
        data-mui-next
        aria-label="Next slide"
        class="absolute right-2 top-1/2 flex size-8 -translate-y-1/2 items-center justify-center rounded-mui-full border border-mui-border bg-mui-surface/90 text-mui-foreground shadow-mui-sm hover:bg-mui-surface-hover disabled:pointer-events-none disabled:opacity-40"
      >
        <svg class="size-4" viewBox="0 0 20 20" fill="none" aria-hidden="true">
          <path
            d="M7.5 5l5 5-5 5"
            stroke="currentColor"
            stroke-width="1.5"
            stroke-linecap="round"
            stroke-linejoin="round"
          />
        </svg>
      </button>

      <div class="mt-3 flex items-center justify-center gap-1.5">
        <button
          :for={{_slide, index} <- Enum.with_index(@slide)}
          type="button"
          data-mui-dot={index}
          aria-label={"Go to slide #{index + 1}"}
          class="size-1.5 rounded-mui-full bg-mui-border transition-colors data-[mui-active=true]:bg-mui-primary"
        />
      </div>
    </div>
    """
  end

  attr :rest, :global

  def hook(assigns) do
    ~H"""
    <script :type={Phoenix.LiveView.ColocatedHook} name=".MUICarousel">
      export default {
        mounted() {
          const root = this.el
          const track = root.querySelector("[data-mui-track]")
          const slides = () => Array.from(track.querySelectorAll("[data-mui-slide]"))
          const dots = () => Array.from(root.querySelectorAll("[data-mui-dot]"))
          const prevBtn = root.querySelector("[data-mui-prev]")
          const nextBtn = root.querySelector("[data-mui-next]")
          let active = 0

          const render = () => {
            dots().forEach((dot) => {
              dot.dataset.muiActive = String(Number(dot.dataset.muiDot) === active)
            })
            if (prevBtn) prevBtn.disabled = active === 0
            if (nextBtn) nextBtn.disabled = active === slides().length - 1
          }

          const goTo = (index) => {
            const target = slides()[Math.max(0, Math.min(index, slides().length - 1))]
            if (target) target.scrollIntoView({ behavior: "smooth", inline: "start", block: "nearest" })
          }

          const observer = new IntersectionObserver(
            (entries) => {
              entries.forEach((entry) => {
                if (entry.isIntersecting && entry.intersectionRatio >= 0.6) {
                  active = Number(entry.target.dataset.muiSlide)
                  render()
                }
              })
            },
            { root: track, threshold: [0.6] }
          )
          slides().forEach((slide) => observer.observe(slide))

          if (prevBtn) prevBtn.addEventListener("click", () => goTo(active - 1))
          if (nextBtn) nextBtn.addEventListener("click", () => goTo(active + 1))
          dots().forEach((dot) => dot.addEventListener("click", () => goTo(Number(dot.dataset.muiDot))))

          root.addEventListener("keydown", (event) => {
            if (event.key === "ArrowLeft") goTo(active - 1)
            if (event.key === "ArrowRight") goTo(active + 1)
          })

          render()
          this.muiObserver = observer
        },
        destroyed() {
          if (this.muiObserver) this.muiObserver.disconnect()
        }
      }
    </script>
    """
  end
end
