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
end
