defmodule MatriarchUIDocsWeb.DocsSidebar do
  @moduledoc "Left navigation shared by every docs page."
  use Phoenix.Component

  use Phoenix.VerifiedRoutes,
    endpoint: MatriarchUIDocsWeb.Endpoint,
    router: MatriarchUIDocsWeb.Router

  alias MatriarchUIDocsWeb.Registry

  attr :active, :string, default: nil

  def sidebar(assigns) do
    assigns = assign(assigns, :components, Registry.components())

    ~H"""
    <nav class="w-56 shrink-0 py-10 pr-6 text-sm">
      <p class="mb-2 px-2 text-xs font-semibold uppercase tracking-wide text-mui-subtle-foreground">
        Getting started
      </p>
      <.link
        navigate={~p"/docs"}
        class={[
          "block rounded-mui-sm px-2 py-1.5",
          is_nil(@active) && "bg-mui-primary-subtle text-mui-primary-subtle-foreground",
          !is_nil(@active) &&
            "text-mui-muted-foreground hover:bg-mui-surface-hover hover:text-mui-foreground"
        ]}
      >
        Installation
      </.link>

      <p class="mb-2 mt-6 px-2 text-xs font-semibold uppercase tracking-wide text-mui-subtle-foreground">
        Components
      </p>
      <.link
        :for={component <- @components}
        navigate={~p"/docs/components/#{component.slug}"}
        class={[
          "block rounded-mui-sm px-2 py-1.5",
          @active == component.slug && "bg-mui-primary-subtle text-mui-primary-subtle-foreground",
          @active != component.slug &&
            "text-mui-muted-foreground hover:bg-mui-surface-hover hover:text-mui-foreground"
        ]}
      >
        {component.title}
      </.link>
    </nav>
    """
  end
end
