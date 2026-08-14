defmodule MatriarchUIDocsWeb.Docs.OverviewLive do
  use MatriarchUIDocsWeb, :live_view
  alias MatriarchUI.I18n
  alias MatriarchUIDocsWeb.{DocsI18n, DocsSidebar, ReaderPresence}

  def mount(params, _session, socket) do
    {reader_topic, reader_count} = ReaderPresence.track(socket, "overview")

    {:ok,
     socket
     |> assign_locale(params)
     |> assign(reader_topic: reader_topic, reader_count: reader_count)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} locale={@locale} language_paths={@language_paths}>
      <div class="mx-auto flex max-w-6xl gap-2 px-6">
        <DocsSidebar.sidebar locale={@locale} />
        <div class="min-w-0 flex-1 border-l border-mui-border py-8 pl-7">
          <h1 class="text-2xl font-semibold tracking-tight text-mui-foreground">
            {DocsI18n.t(@locale, "Installation")}
          </h1>
          <MatriarchUIDocsWeb.ReaderCount.reader_count
            count={@reader_count}
            locale={@locale}
            class="mt-1.5"
          />
          <p class="mt-2 max-w-2xl text-mui-muted-foreground">
            {DocsI18n.t(
              @locale,
              "matriarchUI is a plain Elixir package — Phoenix.Component components, design tokens and a couple of colocated JS hooks. No JS build step, no npm packages to install."
            )}
          </p>

          <ol class="mt-6 flex max-w-2xl flex-col gap-5">
            <li>
              <p class="text-sm font-semibold text-mui-foreground">
                {DocsI18n.t(@locale, "1. Add the dependency")}
              </p>
              <pre class="mt-2 overflow-x-auto rounded-mui-lg border border-mui-border bg-mui-surface-hover p-4 text-xs"><code phx-no-curly-interpolation>{:matriarch_ui, github: "e1berd/matriarch_ui", sparse: "matriarch_ui"}</code></pre>
            </li>
            <li>
              <p class="text-sm font-semibold text-mui-foreground">
                {DocsI18n.t(@locale, "2. Import the design tokens")}
              </p>
              <pre class="mt-2 overflow-x-auto rounded-mui-lg border border-mui-border bg-mui-surface-hover p-4 text-xs"><code phx-no-curly-interpolation>@import "../../deps/matriarch_ui/assets/matriarch_ui.css";</code></pre>
            </li>
            <li>
              <p class="text-sm font-semibold text-mui-foreground">
                {DocsI18n.t(@locale, "3. Import the components")}
              </p>
              <pre class="mt-2 overflow-x-auto rounded-mui-lg border border-mui-border bg-mui-surface-hover p-4 text-xs"><code phx-no-curly-interpolation>use MatriarchUI</code></pre>
              <p class="mt-2 text-sm text-mui-muted-foreground">
                <%= if @locale == "ru" do %>
                  Добавьте эту строку в блок <code class="text-mui-primary">html_helpers</code>
                  файла <code class="text-mui-primary">_web.ex</code>
                  вашего приложения.
                <% else %>
                  Add that inside the <code class="text-mui-primary">html_helpers</code>
                  block of your app's <code class="text-mui-primary">_web.ex</code>.
                <% end %>
              </p>
            </li>
            <li>
              <p class="text-sm font-semibold text-mui-foreground">
                {DocsI18n.t(@locale, "4. Wire up the floating JS hook")}
              </p>
              <pre class="mt-2 overflow-x-auto rounded-mui-lg border border-mui-border bg-mui-surface-hover p-4 text-xs"><code phx-no-curly-interpolation>import {hooks as colocatedHooks} from "phoenix-colocated/my_app"
      import {hooks as matriarchUiHooks} from "phoenix-colocated/matriarch_ui"

      const liveSocket = new LiveSocket("/live", Socket, {
        hooks: {...colocatedHooks, ...matriarchUiHooks},
      })</code></pre>
              <p class="mt-2 text-sm text-mui-muted-foreground">
                <%= if @locale == "ru" do %>
                  Это необходимо для Select, Autocomplete, Scroll Area, Tooltip, Popover и DropdownMenu:
                  colocated hooks каждого приложения находятся в отдельном манифесте, поэтому их нужно
                  один раз объединить в <code class="text-mui-primary">assets/js/app.js</code>.
                <% else %>
                  Needed for Select, Autocomplete, Scroll Area, Tooltip, Popover and DropdownMenu — each app's
                  colocated hooks live in their own manifest, so this merge step is required once in your <code class="text-mui-primary">assets/js/app.js</code>.
                <% end %>
              </p>
            </li>
            <li>
              <p class="text-sm font-semibold text-mui-foreground">
                {DocsI18n.t(@locale, "5. Override the theme")}
              </p>
              <pre class="mt-2 overflow-x-auto rounded-mui-lg border border-mui-border bg-mui-surface-hover p-4 text-xs"><code phx-no-curly-interpolation>:root {
    --color-mui-brand: #2563eb;
    --color-mui-brand-hover: #1d4ed8;
    --color-mui-card: #ffffff;
    --color-mui-card-muted: #f8fafc;
    --color-mui-input-border: rgb(15 23 42 / 14%);
    --gradient-mui-brand-button-highlight: linear-gradient(to bottom, rgb(255 255 255 / 28%), transparent);
    --color-mui-slider-fill-start: #60a5fa;
    --color-mui-slider-fill-end: var(--color-mui-brand);
    --gradient-mui-slider-fill: linear-gradient(to right, #60a5fa, var(--color-mui-brand));
    --color-mui-slider-thumb-border: var(--color-mui-brand);
    --color-mui-scrollbar-track: rgb(37 99 235 / 12%);
    --color-mui-scrollbar-thumb: rgb(37 99 235 / 45%);
    --color-mui-scrollbar-thumb-hover: rgb(37 99 235 / 70%);
    }</code></pre>
              <p class="mt-2 text-sm text-mui-muted-foreground">
                {DocsI18n.t(
                  @locale,
                  "Override semantic tokens after importing matriarchUI. Components consume these variables at runtime, so changing a theme does not require rebuilding the package."
                )}
              </p>
            </li>
          </ol>
        </div>
      </div>
    </Layouts.app>
    """
  end

  def handle_params(params, _uri, socket), do: {:noreply, assign_locale(socket, params)}

  def handle_info(message, socket) do
    if ReaderPresence.diff?(socket.assigns.reader_topic, message) do
      {:noreply, assign(socket, reader_count: ReaderPresence.count(socket.assigns.reader_topic))}
    else
      {:noreply, socket}
    end
  end

  defp assign_locale(socket, params) do
    locale = I18n.normalize_locale(params["locale"])

    assign(socket,
      page_title: I18n.t(locale, "docs.installation"),
      locale: locale,
      language_paths: %{"en" => ~p"/docs", "ru" => ~p"/docs?locale=ru"}
    )
  end
end
