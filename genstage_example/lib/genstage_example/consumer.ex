defmodule GenstageExample.Consumer do
  @moduledoc """
  Demands events from producer-consumer
  """
  use GenStage

  def start_link(_initial) do
    GenStage.start_link(__MODULE__, :state_doesnt_matter)
  end

  def init(state) do
    {:consumer, state, subscribe_to: [GenstageExample.ProducerConsumer]}
  end

  def handle_events(events, _from, state) do
    Process.sleep(1000)

    IO.inspect({self(), events, Enum.count(events), state})

    # As a consumer we never emit events
    {:noreply, [], state}
  end
end
