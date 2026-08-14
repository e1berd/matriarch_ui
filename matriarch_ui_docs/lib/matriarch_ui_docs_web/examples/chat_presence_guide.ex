defmodule MatriarchUIDocsWeb.Examples.ChatPresenceGuide do
  @moduledoc "Phoenix Presence setup for chat participant indicators."
  use Phoenix.Component
  use MatriarchUI

  def guide(assigns) do
    ~H"""
    <section id="chat-presence-guide" class="flex flex-col gap-4">
      <div>
        <p class="text-xs font-semibold uppercase tracking-wide text-mui-accent">
          Phoenix Presence
        </p>
        <h2 class="mt-1 text-xl font-semibold text-mui-foreground">
          Online indicators without a database
        </h2>
        <p class="mt-2 max-w-3xl text-sm leading-6 text-mui-muted-foreground">
          PostgreSQL is not required for an online indicator. Phoenix Presence tracks ephemeral connections through PubSub and removes them when their processes disconnect. Use your database only for persistent profile data or a lasting last-seen timestamp.
        </p>
      </div>

      <div class="flex items-center gap-3 rounded-mui-lg border border-mui-border bg-mui-surface p-4 shadow-mui-xs">
        <.avatar initials="AP" size="sm" />
        <div>
          <p class="text-sm font-medium text-mui-foreground">Ada Phoenix</p>
          <.chat_presence state="online" label="Online on 2 devices" />
        </div>
      </div>

      <div class="grid gap-4 xl:grid-cols-2">
        <.source_panel title="1. Define and supervise Presence" code={presence_module_source()} />
        <.source_panel title="2. Track a participant in LiveView" code={live_view_source()} />
      </div>

      <.source_panel title="3. Render the indicator" code={indicator_source()} />

      <div class="rounded-mui-lg border border-mui-border bg-mui-card-muted/30 p-4 text-sm leading-6 text-mui-muted-foreground">
        Track every connection with the same user id. Presence keeps one metadata entry per browser tab or device, so the user remains online until their final connection closes. Keep metadata small and ephemeral; enrich it in
        <code class="text-mui-foreground">fetch/2</code>
        or your LiveView when profile data is needed.
        See the <.link
          href="https://hexdocs.pm/phoenix/Phoenix.Presence.html"
          target="_blank"
          rel="noreferrer"
          class="font-medium text-mui-primary underline underline-offset-2"
        >
          official Phoenix Presence guide
        </.link>.
      </div>
    </section>
    """
  end

  attr :title, :string, required: true
  attr :code, :string, required: true

  defp source_panel(assigns) do
    ~H"""
    <div class="min-w-0">
      <h3 class="mb-2 text-sm font-semibold text-mui-foreground">{@title}</h3>
      <pre class="overflow-x-auto rounded-mui-lg border border-mui-border bg-mui-surface-hover p-3.5 text-xs leading-5 text-mui-foreground"><code phx-no-curly-interpolation><%= String.trim(@code) %></code></pre>
    </div>
    """
  end

  defp presence_module_source do
    ~S'''
    defmodule MyAppWeb.Presence do
      use Phoenix.Presence,
        otp_app: :my_app,
        pubsub_server: MyApp.PubSub
    end

    children = [
      {Phoenix.PubSub, name: MyApp.PubSub},
      MyAppWeb.Presence,
      MyAppWeb.Endpoint
    ]
    '''
  end

  defp live_view_source do
    ~S'''
    def mount(%{"room_id" => room_id}, _session, socket) do
      topic = "chat:#{room_id}:presence"

      if connected?(socket) do
        Phoenix.PubSub.subscribe(MyApp.PubSub, topic)

        {:ok, _ref} =
          MyAppWeb.Presence.track(
            self(),
            topic,
            to_string(socket.assigns.current_user.id),
            %{status: "online", device: "web"}
          )
      end

      {:ok, assign(socket, presence_topic: topic, presences: MyAppWeb.Presence.list(topic))}
    end

    def handle_info(
          %Phoenix.Socket.Broadcast{topic: topic, event: "presence_diff"},
          %{assigns: %{presence_topic: topic}} = socket
        ) do
      {:noreply, assign(socket, :presences, MyAppWeb.Presence.list(topic))}
    end
    '''
  end

  defp indicator_source do
    ~S'''
    <% online? = Map.has_key?(@presences, to_string(@participant.id)) %>

    <.chat_presence
      state={if online?, do: "online", else: "offline"}
      label={if online?, do: "Online", else: "Offline"}
    />
    '''
  end
end
