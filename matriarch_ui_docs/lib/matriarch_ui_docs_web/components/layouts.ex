defmodule MatriarchUIDocsWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use MatriarchUIDocsWeb, :html

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :locale, :string, default: "en"
  attr :language_paths, :map, default: %{"en" => "/", "ru" => "/?locale=ru"}

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://phoenix.hexdocs.pm/scopes.html)"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <header
      id="docs-header"
      phx-hook=".MUILocale"
      data-docs-locale={@locale}
      class="sticky top-0 z-40 flex h-13 items-center gap-5 border-b border-mui-border bg-mui-surface/80 px-4 backdrop-blur sm:px-6"
    >
      <a
        href={~p"/?#{locale_params(@locale)}"}
        class="flex items-center gap-2 text-[13px] font-semibold tracking-tight text-mui-foreground"
      >
        <span class="flex size-6 items-center justify-center rounded-mui-md bg-mui-accent text-xs text-mui-accent-foreground">
          M
        </span>
        matriarchUI
      </a>
      <nav class="flex items-center gap-4 text-[13px] text-mui-muted-foreground">
        <.link navigate={~p"/docs?#{locale_params(@locale)}"} class="hover:text-mui-foreground">
          {MatriarchUI.I18n.t(@locale, "docs.docs")}
        </.link>
        <.link
          navigate={~p"/docs/components/button?#{locale_params(@locale)}"}
          class="hover:text-mui-foreground"
        >
          {MatriarchUI.I18n.t(@locale, "docs.components")}
        </.link>
      </nav>
      <div class="ml-auto flex items-center gap-2.5">
        <.command_palette id="docs-search">
          <:trigger>
            <.button
              variant="ghost"
              size="sm"
              aria-label={MatriarchUI.I18n.t(@locale, "command_palette.trigger")}
            >
              <.icon name="magnifying-glass" class="size-3.5" />
              <span class="hidden sm:inline">
                {MatriarchUI.I18n.t(@locale, "command_palette.trigger")}
              </span>
              <kbd class="hidden rounded border border-mui-border bg-mui-surface-hover px-1 font-mono text-[10px] text-mui-subtle-foreground sm:inline">
                ⌘K
              </kbd>
            </.button>
          </:trigger>
          <.live_component
            module={MatriarchUIDocsWeb.SearchResultsPanel}
            id="docs-search-results"
            palette_id="docs-search"
            locale={@locale}
          />
        </.command_palette>
        <.dropdown_menu id="docs-language" placement="bottom-end" class="min-w-32">
          <:trigger>
            <.button
              variant="ghost"
              size="sm"
              aria-label={MatriarchUI.I18n.t(@locale, "docs.language")}
            >
              {MatriarchUI.I18n.t(
                @locale,
                if(@locale == "ru", do: "docs.russian", else: "docs.english")
              )}
              <.icon name="caret-down" class="size-3" />
            </.button>
          </:trigger>
          <:item patch={@language_paths["en"]}>{MatriarchUI.I18n.t(@locale, "docs.english")}</:item>
          <:item patch={@language_paths["ru"]}>{MatriarchUI.I18n.t(@locale, "docs.russian")}</:item>
        </.dropdown_menu>
        <a
          href="https://github.com/e1berd/matriarch_ui"
          class="text-[13px] text-mui-muted-foreground hover:text-mui-foreground"
        >
          GitHub
        </a>
        <.theme_toggle locale={@locale} />
      </div>
    </header>

    <main>{render_slot(@inner_block)}</main>

    <.flash_group flash={@flash} locale={@locale} />
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"
  attr :locale, :string, default: "en"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={MatriarchUIDocsWeb.DocsI18n.t(@locale, "We can't find the internet")}
        phx-disconnected={
          show(".phx-client-error #client-error")
          |> JS.remove_attribute("hidden", to: ".phx-client-error #client-error")
        }
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {MatriarchUIDocsWeb.DocsI18n.t(@locale, "Attempting to reconnect")}
        <.icon name="arrows-clockwise" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={MatriarchUIDocsWeb.DocsI18n.t(@locale, "Something went wrong!")}
        phx-disconnected={
          show(".phx-server-error #server-error")
          |> JS.remove_attribute("hidden", to: ".phx-server-error #server-error")
        }
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {MatriarchUIDocsWeb.DocsI18n.t(@locale, "Attempting to reconnect")}
        <.icon name="arrows-clockwise" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Provides dark vs light theme toggle based on themes defined in app.css.

  See <head> in root.html.heex which applies the theme before page load.
  """
  attr :locale, :string, default: "en"

  def theme_toggle(assigns) do
    ~H"""
    <div class="relative flex items-center rounded-mui-full border border-mui-border bg-mui-surface-hover">
      <div class="absolute left-0 h-full w-1/3 rounded-mui-full bg-mui-surface shadow-mui-sm transition-[left] [[data-theme-source=system]_&]:left-0 [[data-theme=light]_&]:left-1/3 [[data-theme=dark]_&]:left-2/3">
      </div>

      <button
        id="theme-system"
        class="z-10 flex w-1/3 cursor-pointer p-1.5"
        aria-label={MatriarchUIDocsWeb.DocsI18n.t(@locale, "System theme")}
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
      >
        <.icon name="desktop" class="size-4 text-mui-muted-foreground" />
      </button>

      <button
        id="theme-light"
        class="z-10 flex w-1/3 cursor-pointer p-1.5"
        aria-label={MatriarchUIDocsWeb.DocsI18n.t(@locale, "Light theme")}
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
      >
        <.icon name="sun" class="size-4 text-mui-muted-foreground" />
      </button>

      <button
        id="theme-dark"
        class="z-10 flex w-1/3 cursor-pointer p-1.5"
        aria-label={MatriarchUIDocsWeb.DocsI18n.t(@locale, "Dark theme")}
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
      >
        <.icon name="moon" class="size-4 text-mui-muted-foreground" />
      </button>
    </div>
    """
  end

  defp locale_params("ru"), do: [locale: "ru"]
  defp locale_params(_locale), do: []

  defp root_locale(%{conn: conn}) do
    MatriarchUI.I18n.normalize_locale(Map.get(conn.query_params, "locale"))
  end

  defp root_locale(_assigns), do: "en"

  attr :rest, :global

  def locale_hook(assigns) do
    ~H"""
    <script :type={Phoenix.LiveView.ColocatedHook} name=".MUILocale">
      export default {
        mounted() {
          document.documentElement.lang = this.el.dataset.docsLocale
        },
        updated() {
          document.documentElement.lang = this.el.dataset.docsLocale
        }
      }
    </script>
    """
  end
end
