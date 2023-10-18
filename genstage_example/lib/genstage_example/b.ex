defmodule GenstageExample.B do
  @moduledoc """
  B is a producer-consumer that will receive those items and multiply them by a given number
  """

  use GenStage

  def start_link(multiplier) do
    GenStage.start_link(B, multiplier)
  end

  def init(multiplier) do
    {:producer_consumer, multiplier}
  end

  def handle_events(events, _from, multiplier) do
    events = Enum.map(events, &(&1 * multiplier))
    {:noreply, events, multiplier}
  end
end
