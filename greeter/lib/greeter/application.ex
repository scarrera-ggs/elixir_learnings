defmodule Greeter.Application do
  use Application

  alias Greeter.GreeterSupervisor

  @impl true
  def start(_type, _args) do
    greeter_supervisor_args = [names: ["santiago", "nadiia", "jorge"]]

    children = [
      {GreeterSupervisor, greeter_supervisor_args}
    ]

    opts = [strategy: :one_for_one, name: Greeter.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
