defmodule GenstageExample.ProducerConsumer do
  @moduledoc """
  Demands numbers from Producer and produce even numbers to Consumer
  """
  use GenStage

  require Integer

  def start_link(_initial) do
    GenStage.start_link(__MODULE__, :state_doesnt_matter, name: __MODULE__)
  end

  def init(state) do
    {:producer_consumer, state, subscribe_to: [{GenstageExample.Producer, max_demand: 250}]}
  end

  def handle_events(events, _from, state) do
    new_events =
      events
      |> Enum.map(fn number -> number + 1 end)

    {:noreply, new_events, state}
  end
end
