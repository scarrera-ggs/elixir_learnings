defmodule SendServer do
  # use Genserver will automatically inject @behaviour GenServer
  # a behaviour in Elixir is similar to an Interface in other languages.
  # So, we will need to implement some function to follow the behaviour/interface
  # this functions are called @callbacks like:
  # init/1 -> This callback runs as soon as the process start and creates the first initial state.
  # handle_call/3 -> This callback will call the server and wait for the result (synchronous).
  # handle_cast/2 -> This callback will call the server and don't wait for the result (asynchronous).
  # handle_continue/2 -> This callback will be triggered after the init/1 is done.
  #   This can be used to make post init functionality like fetching data from a DB.
  # handle_info/2 -> This callback will be trigger by Process.send/2 (generic messages).
  #   Generally is used for system messages.
  # terminate/2 ->
  # start_link/3 ->
  use GenServer

  def init(args) do
    IO.puts("Received arguments: #{inspect(args)}")
    max_retries = Keyword.get(args, :max_retries, 5)
    state = %{emails: [], max_retries: max_retries}

    Process.send_after(self(), :retry, 5000)

    {:ok, state}
    # Possible return values:
    # {:ok, state} -> Start the process and return the state.
    # {:ok, state, {:continue, term}} -> This will call the continue callback after init/1.
    # {:stop, reason} -> stop the process from starting.
    #   If process is supervised then supervisor will restart it.
    # {:ignore} -> stop the process from starting.
    #   If process is supervised then supervisor will not restart it.
  end

  def handle_info(:retry, state) do
    {failed, done} =
      Enum.split_with(state.emails, fn item ->
        item.status == "failed" && item.retries < state.max_retries
      end)

    retried =
      Enum.map(failed, fn item ->
        IO.puts("Retrying email #{item.email}...")

        new_status =
          case Sender.send_email(item.email) do
            {:ok, "email_sent"} -> "sent"
            :error -> "failed"
          end

        %{email: item.email, status: new_status, retries: item.retries + 1}
      end)

    Process.send_after(self(), :retry, 5000)

    {:noreply, %{state | emails: retried ++ done}}
  end

  def handle_continue(:fetch_from_database, state) do
    # Called after init/1
    # This method is not used in our example. Its here to explain what handle_continue does.
    {:noreply, Map.put(state, :users, [])}
    # Possible return values:
    # {:noreply, new_state} -> Return new state.
    # {:noreply, new_state, {:continue, term}} -> This will call another handle_continue/2 to break initialization steps.
    # {:stop, reason, new_state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
    # Possible return values:
    # {:reply, reply, new_state}
    # {:reply, reply, {:continue, term}}
    # {:stop, reason, new_state}
  end

  def handle_cast({:send, email}, state) do
    status =
      case Sender.send_email(email) do
        {:ok, "email_sent"} -> "sent"
        :error -> "failed"
      end

    emails = [%{email: email, status: status, retries: 0}] ++ state.emails

    {:noreply, %{state | emails: emails}}
    # Possible return values:
    # {:noreply, new_state}
    # {:noreply, new_state, {:continue, term}}
    # {:stop, reason, new_state}
  end

  def terminate(reason, _state) do
    IO.puts("Terminating with reason #{reason}")
  end
end
