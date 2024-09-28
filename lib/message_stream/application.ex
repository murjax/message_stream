defmodule MessageStream.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MessageStreamWeb.Telemetry,
      MessageStream.Repo,
      {DNSCluster, query: Application.get_env(:message_stream, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MessageStream.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: MessageStream.Finch},
      # Start a worker by calling: MessageStream.Worker.start_link(arg)
      # {MessageStream.Worker, arg},
      # Start to serve requests, typically the last entry
      MessageStreamWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MessageStream.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MessageStreamWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
