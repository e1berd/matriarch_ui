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

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://phoenix.hexdocs.pm/scopes.html)"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <header class="sticky top-0 z-40 flex h-13 items-center gap-5 border-b border-mui-border bg-mui-surface/80 px-4 backdrop-blur sm:px-6">
      <a
        href="/"
        class="flex items-center gap-2 text-[13px] font-semibold tracking-tight text-mui-foreground"
      >
        <span class="flex size-6 items-center justify-center rounded-mui-sm bg-mui-primary text-xs text-white shadow-mui-button [background-image:linear-gradient(180deg,var(--color-mui-primary),var(--color-mui-primary-hover))]">
          M
        </span>
        matriarchUI
      </a>
      <nav class="flex items-center gap-4 text-[13px] text-mui-muted-foreground">
        <.link navigate={~p"/docs"} class="hover:text-mui-foreground">Docs</.link>
        <.link navigate={~p"/docs/components/button"} class="hover:text-mui-foreground">
          Components
        </.link>
      </nav>
      <div class="ml-auto flex items-center gap-2.5">
        <a
          href="https://github.com/e1berd/matriarch_ui"
          class="text-[13px] text-mui-muted-foreground hover:text-mui-foreground"
        >
          GitHub
        </a>
        <.theme_toggle />
      </div>
    </header>

    <main>{render_slot(@inner_block)}</main>

    <.flash_group flash={@flash} />
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={
          show(".phx-client-error #client-error")
          |> JS.remove_attribute("hidden", to: ".phx-client-error #client-error")
        }
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={
          show(".phx-server-error #server-error")
          |> JS.remove_attribute("hidden", to: ".phx-server-error #server-error")
        }
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Provides dark vs light theme toggle based on themes defined in app.css.

  See <head> in root.html.heex which applies the theme before page load.
  """
  def theme_toggle(assigns) do
    ~H"""
    <div class="relative flex items-center rounded-mui-full border border-mui-border bg-mui-surface-hover">
      <div class="absolute left-0 h-full w-1/3 rounded-mui-full bg-mui-surface shadow-mui-sm transition-[left] [[data-theme-source=system]_&]:left-0 [[data-theme=light]_&]:left-1/3 [[data-theme=dark]_&]:left-2/3">
      </div>

      <button
        class="z-10 flex w-1/3 cursor-pointer p-1.5"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
      >
        <.icon name="hero-computer-desktop-micro" class="size-4 text-mui-muted-foreground" />
      </button>

      <button
        class="z-10 flex w-1/3 cursor-pointer p-1.5"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
      >
        <.icon name="hero-sun-micro" class="size-4 text-mui-muted-foreground" />
      </button>

      <button
        class="z-10 flex w-1/3 cursor-pointer p-1.5"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
      >
        <.icon name="hero-moon-micro" class="size-4 text-mui-muted-foreground" />
      </button>
    </div>
    """
  end
end
