defmodule MatriarchUIDocsWeb.LandingLive do
  use MatriarchUIDocsWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "matriarchUI")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <section class="relative overflow-hidden px-6 pb-16 pt-16 sm:pt-20">
        <div class="pointer-events-none absolute inset-x-0 top-0 -z-10 h-[420px] bg-gradient-to-b from-mui-accent/10 via-mui-accent/5 to-transparent">
        </div>
        <div class="mx-auto max-w-2xl text-center">
          <span class="inline-flex items-center rounded-mui-full border border-mui-border bg-mui-surface px-2.5 py-0.5 text-xs font-medium text-mui-muted-foreground shadow-mui-xs">
            Built for Phoenix LiveView
          </span>
          <h1 class="mt-5 text-4xl font-bold tracking-tight text-mui-foreground sm:text-5xl">
            Interfaces that feel <span class="text-mui-accent">inevitable</span>.
          </h1>
          <p class="mx-auto mt-4 max-w-lg text-base text-mui-muted-foreground">
            A Clerk/Mosaic-inspired component kit for Phoenix LiveView. No daisyUI,
            no npm, no build step — just Elixir, Tailwind and a few colocated hooks.
          </p>
          <div class="mt-6 flex flex-wrap items-center justify-center gap-2.5">
            <.button variant="brand" navigate={~p"/docs"}>Browse the docs</.button>
            <.button variant="outline" href="https://github.com/e1berd/matriarch_ui">
              View on GitHub
            </.button>
          </div>
          <pre class="mx-auto mt-6 max-w-md overflow-x-auto rounded-mui-lg border border-mui-border bg-mui-surface p-3.5 text-left text-xs shadow-mui-xs"><code phx-no-curly-interpolation>{:matriarch_ui, github: "e1berd/matriarch_ui", sparse: "matriarch_ui"}</code></pre>
        </div>
      </section>

      <section class="border-y border-mui-border bg-mui-surface px-6 py-10">
        <div class="mx-auto max-w-5xl">
          <div class="flex flex-wrap items-center justify-center gap-3 rounded-mui-lg border border-mui-border bg-mui-background p-5 shadow-mui-sm">
            <.button variant="brand">Brand</.button>
            <.button>Solid</.button>
            <.button variant="outline">Outline</.button>
            <.badge variant="primary">New</.badge>
            <.switch name="demo-switch" id="demo-switch" checked />
            <.avatar initials="MU" />
            <.tooltip id="demo-tip" text="It just works">
              <.badge variant="outline">Hover me</.badge>
            </.tooltip>
          </div>
        </div>
      </section>

      <section class="px-6 py-16">
        <div class="mx-auto grid max-w-5xl gap-4 sm:grid-cols-2 lg:grid-cols-4">
          <div
            :for={feature <- features()}
            class="rounded-mui-lg border border-mui-border bg-mui-surface p-5 shadow-mui-xs"
          >
            <h3 class="text-sm font-semibold tracking-tight text-mui-foreground">{feature.title}</h3>
            <p class="mt-1.5 text-sm text-mui-muted-foreground">{feature.description}</p>
          </div>
        </div>
      </section>

      <footer class="border-t border-mui-border px-6 py-8 text-center text-sm text-mui-subtle-foreground">
        matriarchUI is MIT licensed. Built with matriarchUI itself.
      </footer>
    </Layouts.app>
    """
  end

  defp features do
    [
      %{
        title: "Own your styling",
        description: "Every color is a CSS variable. Override them once, no rebuild needed."
      },
      %{
        title: "Floating, built in",
        description:
          "Select, Tooltip, Popover and DropdownMenu share one self-contained positioning engine."
      },
      %{
        title: "Ships as a hex package",
        description:
          "Colocated hooks bundle automatically into any app that depends on it. No npm."
      },
      %{
        title: "Accessible by default",
        description: "Real ARIA roles, keyboard navigation and focus handling out of the box."
      }
    ]
  end
end
