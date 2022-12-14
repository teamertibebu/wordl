defmodule Wordl.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      WordlWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Wordl.PubSub},
      # Start the Endpoint (http/https)
      WordlWeb.Endpoint
      # Start a worker by calling: Wordl.Worker.start_link(arg)
      # {Wordl.Worker, arg}
    ]

    case Code.ensure_loaded(ExSync) do
      {:module, ExSync = mod} ->
        mod.start()

      {:error, :nofile} ->
        :ok
    end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Wordl.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WordlWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
