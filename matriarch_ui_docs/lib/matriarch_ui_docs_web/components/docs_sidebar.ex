defmodule MatriarchUIDocsWeb.DocsSidebar do
  @moduledoc "Left navigation shared by every docs page."
  use Phoenix.Component

  use Phoenix.VerifiedRoutes,
    endpoint: MatriarchUIDocsWeb.Endpoint,
    router: MatriarchUIDocsWeb.Router

  alias MatriarchUIDocsWeb.Registry

  attr :active, :string, default: nil
  attr :locale, :string, default: "en"

  def sidebar(assigns) do
    assigns = assign(assigns, :components, Registry.components())

    ~H"""
    <nav class="w-52 shrink-0 py-8 pr-5 text-[13px]">
      <p class="mb-1.5 px-2 text-[11px] font-semibold uppercase tracking-wide text-mui-subtle-foreground">
        {MatriarchUI.I18n.t(@locale, "docs.getting_started")}
      </p>
      <.link
        navigate={~p"/docs?#{locale_params(@locale)}"}
        class={[
          "block rounded-mui-md px-2 py-1",
          is_nil(@active) && "bg-mui-primary-subtle text-mui-primary-subtle-foreground",
          !is_nil(@active) &&
            "text-mui-muted-foreground hover:bg-mui-surface-hover hover:text-mui-foreground"
        ]}
      >
        {MatriarchUI.I18n.t(@locale, "docs.installation")}
      </.link>

      <p class="mb-1.5 mt-5 px-2 text-[11px] font-semibold uppercase tracking-wide text-mui-subtle-foreground">
        {MatriarchUI.I18n.t(@locale, "docs.components")}
      </p>
      <.link
        :for={component <- @components}
        navigate={~p"/docs/components/#{component.slug}?#{locale_params(@locale)}"}
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

  defp locale_params("ru"), do: [locale: "ru"]
  defp locale_params(_locale), do: []
end
