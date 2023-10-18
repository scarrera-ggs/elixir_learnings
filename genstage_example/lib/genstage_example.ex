defmodule GenstageExample do
  @moduledoc """
  GenStage pipeline: [A] -> [B] -> [C]

  We conclude that:
  A is only a producer (and therefore a source)
  B is both producer and consumer
  C is only a consumer (and therefore a sink)

  Tip to build back-pressure systems:

  DO NOT do this:
  [Producer] -> [Step 1] -> [Step 2] -> [Step 3]

  DO this:
               [Consumer]
            /
  [Producer]-<-[Consumer]
            \
             [Consumer]
  """

  def run_pipeline do
    # starting from zero
    {:ok, a} = GenstageExample.A.start_link(0)
    # multiply by 2
    {:ok, b} = GenstageExample.B.start_link(2)
    # state does not matter
    {:ok, c} = GenstageExample.C.start_link([])

    # Typically, we subscribe from bottom to top.
    # Since A will start producing items only when B connects to it,
    # we want this subscription to happen when the whole pipeline is ready.
    # After you subscribe all of them, demand will start flowing upstream and events downstream.
    GenStage.sync_subscribe(c, to: b)
    GenStage.sync_subscribe(b, to: a)
  end
end
