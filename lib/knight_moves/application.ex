defmodule KnightMoves.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl Application
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      KnightMoves.Repo,
      # Start the Telemetry supervisor
      KnightMovesWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: KnightMoves.PubSub},
      # Start the Endpoint (http/https)
      KnightMovesWeb.Endpoint
      # Start a worker by calling: KnightMoves.Worker.start_link(arg)
      # {KnightMoves.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: KnightMoves.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl Application
  def config_change(changed, _new, removed) do
    KnightMovesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
