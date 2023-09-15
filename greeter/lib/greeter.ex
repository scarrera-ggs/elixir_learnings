defmodule Greeter do
  require Logger
  @type action :: :send | :stop

  @spec greet(action :: action(), name :: String.t(), opts :: keyword()) ::
          {:ok | {:error, :not_found}} | {:error, term()}
  def greet(action, name, opts \\ [])

  def greet(:send, name, _opts) do
    IO.puts("Hello #{name}")
  end
end
