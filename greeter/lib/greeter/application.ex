defmodule Greeter.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: Greeter.Registry}
    ]

    opts = [strategy: :one_for_one, name: Greeter.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
