defmodule MatriarchUIDocs.DraggableStore do
  @moduledoc "Bounded in-memory order storage for realtime draggable collections."
  use GenServer

  @cleanup_interval :timer.minutes(5)
  @idle_timeout :timer.hours(1)
  @max_documents 128

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def open(document, initial_order) do
    GenServer.call(__MODULE__, {:open, document, initial_order})
  end

  def reorder(document, order), do: GenServer.call(__MODULE__, {:reorder, document, order})
  def close(document), do: GenServer.cast(__MODULE__, {:close, document})
  def reset(document), do: GenServer.call(__MODULE__, {:reset, document})

  @impl true
  def init(_state) do
    schedule_cleanup()
    {:ok, %{}}
  end

  @impl true
  def handle_call({:open, document, initial_order}, _from, documents) do
    now = System.monotonic_time(:millisecond)

    case Map.fetch(documents, document) do
      {:ok, state} ->
        if MapSet.equal?(MapSet.new(state.order), MapSet.new(initial_order)) do
          state = %{state | subscribers: state.subscribers + 1, touched_at: now}
          {:reply, {:ok, public_state(state)}, Map.put(documents, document, state)}
        else
          {:reply, {:error, :invalid_order}, documents}
        end

      :error when map_size(documents) < @max_documents ->
        state = %{order: initial_order, version: 0, subscribers: 1, touched_at: now}
        {:reply, {:ok, public_state(state)}, Map.put(documents, document, state)}

      :error ->
        {:reply, {:error, :capacity}, documents}
    end
  end

  def handle_call({:reorder, document, order}, _from, documents) do
    case Map.fetch(documents, document) do
      {:ok, state} ->
        if MapSet.equal?(MapSet.new(state.order), MapSet.new(order)) do
          state = %{
            state
            | order: order,
              version: state.version + 1,
              touched_at: System.monotonic_time(:millisecond)
          }

          {:reply, {:ok, state.version}, Map.put(documents, document, state)}
        else
          {:reply, {:error, :invalid_order}, documents}
        end

      :error ->
        {:reply, {:error, :not_found}, documents}
    end
  end

  def handle_call({:reset, document}, _from, documents) do
    {:reply, :ok, Map.delete(documents, document)}
  end

  @impl true
  def handle_cast({:close, document}, documents) do
    documents =
      Map.update(documents, document, nil, fn state ->
        %{state | subscribers: max(state.subscribers - 1, 0)}
      end)
      |> Map.reject(fn {_document, state} -> is_nil(state) end)

    {:noreply, documents}
  end

  @impl true
  def handle_info(:cleanup, documents) do
    cutoff = System.monotonic_time(:millisecond) - @idle_timeout

    documents =
      Map.reject(documents, fn {_document, state} ->
        state.subscribers == 0 and state.touched_at < cutoff
      end)

    schedule_cleanup()
    {:noreply, documents}
  end

  defp public_state(state), do: %{order: state.order, version: state.version}
  defp schedule_cleanup, do: Process.send_after(self(), :cleanup, @cleanup_interval)
end
