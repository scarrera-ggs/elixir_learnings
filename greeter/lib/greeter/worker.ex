defmodule Greeter.Worker do
  use GenServer

  def start_link(opts) do
    name = Keyword.fetch!(opts, :name)
    GenServer.start_link(__MODULE__, opts, name: via(name))
  end

  def init(opts) do
    name = Keyword.fetch!(opts, :name)
    greet_interval = Keyword.fetch!(opts, :greet_interval)

    IO.inspect("Hello #{name}")

    ref = Process.send_after(self(), :resend, greet_interval)
    state = %{name: name, greet_interval: greet_interval, ref: ref}

    {:ok, state}
  end

  def handle_info(:resend, state) do
    IO.inspect("Hello #{state.name}")
    ref = Process.send_after(self(), :resend, state.greet_interval)

    {:noreply, %{state | ref: ref}}
  end

  def handle_call(:stop, _from, state) do
    IO.inspect("Process stopped")
    Process.cancel_timer(state.ref)

    {:reply, :ok, state}
  end

  def handle_call(:shutdown, _from, state) do
    IO.inspect("Process shutdown")

    {:stop, :normal, :ok, state}
  end

  def handle_call(:restart, _from, state) do
    IO.inspect("Hello #{state.name}")
    ref = Process.send_after(self(), :resend, state.greet_interval)

    {:reply, :ok, %{state | ref: ref}}
  end

  defp via(name) do
    {:via, Registry, {Greeter.Registry, name}}
  end

  def restart(name) do
    GenServer.call(via(name), :restart)
  end

  def stop(name) do
    GenServer.call(via(name), :stop)
  end

  def shutdown(name) do
    GenServer.call(via(name), :shutdown)
  end
end
