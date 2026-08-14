defmodule MatriarchUIDocsWeb.SearchPalette do
  @moduledoc "⌘K command palette: searches component names and page content, locale-aware."
  use Phoenix.LiveComponent

  use Phoenix.VerifiedRoutes,
    endpoint: MatriarchUIDocsWeb.Endpoint,
    router: MatriarchUIDocsWeb.Router

  use MatriarchUI
  alias MatriarchUI.I18n
  alias MatriarchUIDocsWeb.Search
  alias Phoenix.LiveView.JS

  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_new(:query, fn -> "" end)
      |> assign_new(:results, fn -> [] end)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div id={@id}>
      <button
        type="button"
        id={"#{@id}-trigger"}
        phx-hook=".ShortcutOpen"
        phx-click={MatriarchUI.Modal.show_modal("#{@id}-modal") |> JS.focus(to: "##{@id}-input")}
        class="flex h-7 items-center gap-2 rounded-mui-md border border-mui-border bg-mui-surface px-2.5 text-[13px] text-mui-muted-foreground hover:bg-mui-surface-hover hover:text-mui-foreground"
        aria-label={I18n.t(@locale, "docs.search")}
      >
        <.icon name="magnifying-glass" class="size-3.5" />
        <span class="hidden sm:inline">{I18n.t(@locale, "docs.search")}</span>
        <kbd class="hidden rounded border border-mui-border bg-mui-surface-hover px-1 font-mono text-[10px] text-mui-subtle-foreground sm:inline">
          ⌘K
        </kbd>
      </button>

      <.modal id={"#{@id}-modal"} class="max-w-lg">
        <.input
          id={"#{@id}-input"}
          name="query"
          value={@query}
          autocomplete="off"
          placeholder={I18n.t(@locale, "docs.search_placeholder")}
          phx-change="search"
          phx-debounce="150"
          phx-target={@myself}
        >
          <:leading><.icon name="magnifying-glass" class="size-4" /></:leading>
        </.input>

        <ul :if={@results != []} class="mt-3 flex flex-col gap-0.5">
          <li :for={result <- @results}>
            <.link
              navigate={~p"/docs/components/#{result.slug}?#{locale_params(@locale)}"}
              class="block rounded-mui-md px-2.5 py-2 hover:bg-mui-surface-hover"
            >
              <p class="text-sm font-medium text-mui-foreground">{result.title}</p>
              <p :if={result.snippet} class="mt-0.5 text-xs text-mui-muted-foreground">
                {result.snippet}
              </p>
            </.link>
          </li>
        </ul>

        <p :if={@query != "" and @results == []} class="mt-3 text-sm text-mui-muted-foreground">
          {I18n.t(@locale, "docs.search_empty")}
        </p>
      </.modal>

      <script :type={Phoenix.LiveView.ColocatedHook} name=".ShortcutOpen">
        export default {
          mounted() {
            this.onKeydown = (event) => {
              const key = event.key.toLowerCase()
              if ((event.metaKey || event.ctrlKey) && key === "k") {
                event.preventDefault()
                this.el.click()
              }
            }
            window.addEventListener("keydown", this.onKeydown)
          },
          destroyed() {
            window.removeEventListener("keydown", this.onKeydown)
          }
        }
      </script>
    </div>
    """
  end

  def handle_event("search", %{"query" => query}, socket) do
    results = Search.search(query, socket.assigns.locale)
    {:noreply, assign(socket, query: query, results: results)}
  end

  defp locale_params("ru"), do: [locale: "ru"]
  defp locale_params(_locale), do: []
end
