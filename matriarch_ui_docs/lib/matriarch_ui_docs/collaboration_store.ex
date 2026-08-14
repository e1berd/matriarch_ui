defmodule MatriarchUIDocs.CollaborationStore do
  @moduledoc "Bounded in-memory storage for collaborative Yjs documents."
  use GenServer

  @cleanup_interval :timer.minutes(5)
  @idle_timeout :timer.hours(1)
  @max_documents 128
  @max_document_bytes 8 * 1024 * 1024
  @max_update_bytes 256 * 1024

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def open(document), do: GenServer.call(__MODULE__, {:open, document})
  def append(document, update), do: GenServer.call(__MODULE__, {:append, document, update})

  def compact(document, version, snapshot) do
    GenServer.call(__MODULE__, {:compact, document, version, snapshot})
  end

  def close(document), do: GenServer.cast(__MODULE__, {:close, document})
  def reset(document), do: GenServer.call(__MODULE__, {:reset, document})

  @impl true
  def init(_state) do
    schedule_cleanup()
    {:ok, %{}}
  end

  @impl true
  def handle_call({:open, document}, _from, documents) do
    now = System.monotonic_time(:millisecond)

    case Map.fetch(documents, document) do
      {:ok, state} ->
        state = %{state | subscribers: state.subscribers + 1, touched_at: now}
        {:reply, {:ok, sync_state(state)}, Map.put(documents, document, state)}

      :error when map_size(documents) < @max_documents ->
        state = empty_state(now)
        {:reply, {:ok, sync_state(state)}, Map.put(documents, document, state)}

      :error ->
        {:reply, {:error, :capacity}, documents}
    end
  end

  def handle_call({:append, document, update}, _from, documents) do
    with :ok <- valid_update_size(update),
         {:ok, state} <- Map.fetch(documents, document),
         :ok <- valid_document_size(state.bytes + byte_size(update)) do
      version = state.version + 1

      state = %{
        state
        | updates: [update | state.updates],
          version: version,
          bytes: state.bytes + byte_size(update),
          touched_at: System.monotonic_time(:millisecond)
      }

      {:reply, {:ok, version}, Map.put(documents, document, state)}
    else
      :error -> {:reply, {:error, :not_found}, documents}
      {:error, reason} -> {:reply, {:error, reason}, documents}
    end
  end

  def handle_call({:compact, document, version, snapshot}, _from, documents) do
    with :ok <- valid_document_size(byte_size(snapshot)),
         {:ok, %{version: ^version} = state} <- Map.fetch(documents, document) do
      state = %{
        state
        | snapshot: snapshot,
          updates: [],
          bytes: byte_size(snapshot),
          touched_at: System.monotonic_time(:millisecond)
      }

      {:reply, :ok, Map.put(documents, document, state)}
    else
      :error -> {:reply, {:error, :not_found}, documents}
      {:ok, _state} -> {:reply, {:error, :stale}, documents}
      {:error, reason} -> {:reply, {:error, reason}, documents}
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

  defp empty_state(now) do
    %{snapshot: <<>>, updates: [], version: 0, bytes: 0, subscribers: 1, touched_at: now}
  end

  defp sync_state(state) do
    %{snapshot: state.snapshot, updates: Enum.reverse(state.updates), version: state.version}
  end

  defp valid_update_size(update) when byte_size(update) in 1..@max_update_bytes, do: :ok
  defp valid_update_size(_update), do: {:error, :update_too_large}

  defp valid_document_size(size) when size <= @max_document_bytes, do: :ok
  defp valid_document_size(_size), do: {:error, :document_too_large}

  defp schedule_cleanup do
    Process.send_after(self(), :cleanup, @cleanup_interval)
  end
end
