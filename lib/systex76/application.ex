defmodule Systex76.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Systex76.Repo,
      # Start the Telemetry supervisor
      Systex76Web.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Systex76.PubSub},
      # Start the Endpoint (http/https)
      Systex76Web.Endpoint,
      # Start a worker by calling: Systex76.Worker.start_link(arg)
      # {Systex76.Worker, arg}
      {Oban, oban_config()}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Systex76.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Systex76Web.Endpoint.config_change(changed, removed)
    :ok
  end

  defp oban_config do
    Application.get_env(:systex76, Oban)
  end
end
