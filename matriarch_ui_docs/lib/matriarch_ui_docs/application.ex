defmodule MatriarchUIDocs.Application do
  # See https://elixir.hexdocs.pm/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MatriarchUIDocsWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:matriarch_ui_docs, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MatriarchUIDocs.PubSub},
      MatriarchUIDocsWeb.Presence,
      MatriarchUIDocs.ChatStore,
      MatriarchUIDocs.CollaborationStore,
      # Start a worker by calling: MatriarchUIDocs.Worker.start_link(arg)
      # {MatriarchUIDocs.Worker, arg},
      # Start to serve requests, typically the last entry
      MatriarchUIDocsWeb.Endpoint
    ]

    # See https://elixir.hexdocs.pm/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MatriarchUIDocs.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MatriarchUIDocsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
