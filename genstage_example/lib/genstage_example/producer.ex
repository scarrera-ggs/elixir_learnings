defmodule GenstageExample.Producer do
  @moduledoc """
  Produce numbers
  """
  use GenStage

  def start_link(initial \\ 0) do
    GenStage.start_link(__MODULE__, initial, name: __MODULE__)
  end

  def init(counter), do: {:producer, counter}

  def handle_demand(demand, state) do
    IO.inspect(demand, label: "Upstream Demand")

    events = Enum.to_list(state..(state + demand - 1))
    {:noreply, events, state + demand}
  end
end
