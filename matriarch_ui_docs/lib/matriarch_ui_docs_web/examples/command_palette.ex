defmodule MatriarchUIDocsWeb.Examples.CommandPalette do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase
  alias MatriarchUIDocsWeb.DocsI18n

  def search_content(_locale) do
    "search over anything database HTTP call in-process list command palette dialog keyboard navigation highlight live component mode search raw fixed tool action picker icon phosphor"
  end

  def examples(assigns) do
    assigns =
      assigns
      |> Map.put(:live_component_source, live_component_source())
      |> Map.put(:plain_liveview_source, plain_liveview_source())

    ~H"""
    <.example
      locale={@locale}
      title={"mode=\"search\""}
      description={"MatriarchUI.CommandPalette never touches your data — it only renders the trigger, dialog and results, and highlights title/subtitle against the current query for you. You write a small LiveComponent that owns query/results and looks them up however you like; the one below (shown in full further down this page) searches a handful of hardcoded names, but the same shape works over a database or an HTTP call. mode=\"search\" waits for a query before showing anything, with an idle hint until then."}
      code={
        ~S'''
        <.command_palette id="demo-command-palette">
          <:trigger><.button>Search</.button></:trigger>
          <.live_component
            module={MatriarchUIDocsWeb.Examples.CommandPaletteDemo}
            id="demo-command-palette-results"
            palette_id="demo-command-palette"
          />
        </.command_palette>
        '''
      }
    >
      <.command_palette id="demo-command-palette">
        <:trigger>
          <.button>{MatriarchUI.I18n.t(@locale, "command_palette.trigger")}</.button>
        </:trigger>
        <.live_component
          module={MatriarchUIDocsWeb.Examples.CommandPaletteDemo}
          id="demo-command-palette-results"
          palette_id="demo-command-palette"
          locale={@locale}
        />
      </.command_palette>
    </.example>

    <.example
      locale={@locale}
      title={"mode=\"raw\" (the default)"}
      description="Leave mode at its default and seed results with everything up front — the full list (each with a leading phosphor icon) shows before the reader types anything, and your own handle_event narrows it down as they do. Good for a command menu of actions rather than a search over content."
      code={
        ~S'''
        <.command_palette id="demo-command-palette-tools">
          <:trigger><.button>Actions</.button></:trigger>
          <.live_component
            module={MatriarchUIDocsWeb.Examples.CommandPaletteToolsDemo}
            id="demo-command-palette-tools-results"
            palette_id="demo-command-palette-tools"
          />
        </.command_palette>
        '''
      }
    >
      <.command_palette id="demo-command-palette-tools">
        <:trigger>
          <.button>{DocsI18n.t(@locale, "Actions")}</.button>
        </:trigger>
        <.live_component
          module={MatriarchUIDocsWeb.Examples.CommandPaletteToolsDemo}
          id="demo-command-palette-tools-results"
          palette_id="demo-command-palette-tools"
          locale={@locale}
        />
      </.command_palette>
    </.example>

    <div class="flex flex-col gap-3">
      <div>
        <h3 class="text-sm font-semibold text-mui-foreground">
          {DocsI18n.t(@locale, "The LiveComponent above, in full")}
        </h3>
        <p class="text-sm text-mui-muted-foreground">
          {DocsI18n.t(
            @locale,
            "This is everything MatriarchUIDocsWeb.Examples.CommandPaletteDemo does: own query/results, handle the search event, look results up. title/subtitle are plain strings — no highlighting math required."
          )}
        </p>
      </div>
      <pre class="overflow-x-auto rounded-mui-lg border border-mui-border bg-mui-surface-hover p-3.5 text-xs text-mui-foreground"><code phx-no-curly-interpolation>{@live_component_source}</code></pre>
    </div>

    <div class="flex flex-col gap-3">
      <div>
        <h3 class="text-sm font-semibold text-mui-foreground">
          {DocsI18n.t(@locale, "Without a LiveComponent")}
        </h3>
        <p class="text-sm text-mui-muted-foreground">
          {DocsI18n.t(
            @locale,
            "The LiveComponent only matters if this page re-renders often for unrelated reasons — like this docs site's own header search does. If yours doesn't, own query/results on the LiveView itself:"
          )}
        </p>
      </div>
      <pre class="overflow-x-auto rounded-mui-lg border border-mui-border bg-mui-surface-hover p-3.5 text-xs text-mui-foreground"><code phx-no-curly-interpolation>{@plain_liveview_source}</code></pre>
    </div>

    <.props_table
      locale={@locale}
      rows={[
        {"id", "string, required", "unique id, shared with the paired command_palette_search"},
        {"query", "string", "current search box value"},
        {"event", "string, required", "phx-change event name pushed as the reader types"},
        {"target", "any", "phx-target, e.g. @myself in a LiveComponent"},
        {"max_length", "integer", "maxlength of the search input, defaults to 80"},
        {"mode", "\"search\" | \"raw\"",
         "raw (default) always renders command; search waits for a query, with an idle hint until then"},
        {"command", "slot",
         "one per result; id/value required, icon optional (a phosphor icon name), title/subtitle plain strings, auto-highlighted"}
      ]}
    />
    """
  end

  defp live_component_source do
    ~S'''
    defmodule MyAppWeb.CommandPaletteResults do
      use Phoenix.LiveComponent
      use MyAppWeb, :verified_routes

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
          <.command_palette_search
            id={@palette_id}
            query={@query}
            event="search"
            target={@myself}
            mode="search"
          >
            <:command
              :for={result <- @results}
              id={result.id}
              value={result.url}
              icon={result.icon}
              title={result.title}
              subtitle={result.description}
            />
          </.command_palette_search>
        </div>
        """
      end

      def handle_event("search", %{"search" => %{"query" => query}}, socket) do
        {:noreply, assign(socket, query: query, results: MyApp.Search.run(query))}
      end
    end
    '''
    |> String.trim()
  end

  defp plain_liveview_source do
    ~S'''
    def handle_event("search", %{"search" => %{"query" => query}}, socket) do
      {:noreply, assign(socket, query: query, results: MyApp.Search.run(query))}
    end

    # in your template
    <.command_palette id="search">
      <:trigger><.button>Search</.button></:trigger>
      <.command_palette_search id="search" query={@query} event="search" mode="search">
        <:command
          :for={result <- @results}
          id={result.id}
          value={result.url}
          icon={result.icon}
          title={result.title}
          subtitle={result.description}
        />
      </.command_palette_search>
    </.command_palette>
    '''
    |> String.trim()
  end
end
