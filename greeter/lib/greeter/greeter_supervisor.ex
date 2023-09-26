defmodule Greeter.GreeterSupervisor do
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: Greeter.GreeterSupervisor)
  end

  def init(args) do
    names = Keyword.fetch!(args, :names)

    children = [
      {Registry, keys: :unique, name: Greeter.Registry}
      | generate_children(names)
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp generate_children(names_to_greet) do
    names_to_greet
    |> Enum.map(fn name ->
      Supervisor.child_spec(
        {Greeter.Greet, [name: name, greet_interval: 3000]},
        id: "#{name}-#{random_job_id()}",
        restart: :transient
      )

      # %{
      #   id: "#{name}-#{random_job_id}",
      #   start: {Greeter.Greet, :start_link, [[name: name, greet_interval: 3000]]}
      # }
    end)
  end

  defp random_job_id do
    :crypto.strong_rand_bytes(5) |> Base.url_encode64(padding: false)
  end
end
