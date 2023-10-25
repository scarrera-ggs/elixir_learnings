defmodule GenstageExample.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {GenstageExample.Producer, 0},
      {GenstageExample.ProducerConsumer, []},
      {GenstageExample.Consumer, []}

      # multiple consumers
      # Supervisor.child_spec({GenstageExample.Consumer, []}, id: :c1),
      # Supervisor.child_spec({GenstageExample.Consumer, []}, id: :c2)
    ]

    opts = [strategy: :rest_for_one, name: GenstageExample.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
