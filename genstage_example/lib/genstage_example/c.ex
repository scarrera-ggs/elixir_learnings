defmodule GenstageExample.C do
  @moduledoc """
  C will receive B events and print them to the terminal.
  """

  use GenStage

  def start_link(_opts) do
    GenStage.start_link(C, :ok)
  end

  def init(:ok) do
    {:consumer, :the_state_does_not_matter}
  end

  def handle_events(events, _from, state) do
    # Wait for a second.
    Process.sleep(1000)

    # Inspect the events.
    IO.inspect(events)

    # We are a consumer, so we would never emit items.
    {:noreply, [], state}
  end
end
