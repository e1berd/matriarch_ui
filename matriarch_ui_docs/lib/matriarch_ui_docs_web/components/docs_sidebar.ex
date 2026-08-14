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
    <nav class="w-52 shrink-0 py-8 pr-5 text-[13px]">
      <p class="mb-1.5 px-2 text-[11px] font-semibold uppercase tracking-wide text-mui-subtle-foreground">
        Getting started
      </p>
      <.link
        navigate={~p"/docs"}
        class={[
          "block rounded-mui-md px-2 py-1",
          is_nil(@active) && "bg-mui-primary-subtle text-mui-primary-subtle-foreground",
          !is_nil(@active) &&
            "text-mui-muted-foreground hover:bg-mui-surface-hover hover:text-mui-foreground"
        ]}
      >
        Installation
      </.link>

      <p class="mb-1.5 mt-5 px-2 text-[11px] font-semibold uppercase tracking-wide text-mui-subtle-foreground">
        Components
      </p>
      <.link
        :for={component <- @components}
        navigate={~p"/docs/components/#{component.slug}"}
        class={[
          "block rounded-mui-md px-2 py-1",
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
