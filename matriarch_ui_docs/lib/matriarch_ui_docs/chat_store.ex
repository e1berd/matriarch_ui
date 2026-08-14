defmodule MatriarchUIDocs.ChatStore do
  @moduledoc "Bounded in-memory message store for the public chat example."
  use GenServer
  alias MatriarchUIDocs.ChatMessage

  @message_topic "docs_chat:messages"
  @maximum_messages 1_000

  def start_link(_opts), do: GenServer.start_link(__MODULE__, :ok, name: __MODULE__)

  def message_topic, do: @message_topic

  def window(limit, offset), do: GenServer.call(__MODULE__, {:window, limit, offset})

  def around(message_id, radius), do: GenServer.call(__MODULE__, {:around, message_id, radius})

  def append(attrs), do: GenServer.call(__MODULE__, {:append, attrs})

  @impl true
  def init(:ok) do
    messages = seeded_messages()
    {:ok, %{messages: messages, sequence: length(messages)}}
  end

  @impl true
  def handle_call({:window, limit, offset}, _from, state) do
    total = length(state.messages)
    limit = limit |> max(1) |> min(128)
    offset = offset |> max(0) |> min(max(total - limit, 0))
    messages = Enum.slice(state.messages, offset, limit)
    {:reply, window_result(messages, offset, total), state}
  end

  def handle_call({:around, message_id, radius}, _from, state) do
    radius = radius |> max(1) |> min(128)
    total = length(state.messages)

    case Enum.find_index(state.messages, &(&1.id == message_id)) do
      nil ->
        offset = max(total - radius, 0)
        messages = Enum.slice(state.messages, offset, radius)
        {:reply, Map.put(window_result(messages, offset, total), :target, nil), state}

      index ->
        offset = max(index - radius, 0)
        count = min(index + radius, total - 1) - offset + 1
        messages = Enum.slice(state.messages, offset, count)
        result = window_result(messages, offset, total) |> Map.put(:target, message_id)
        {:reply, result, state}
    end
  end

  def handle_call({:append, attrs}, _from, state) do
    sequence = state.sequence + 1

    message = %ChatMessage{
      id: "message-#{sequence}",
      author_id: attrs.author_id,
      author_name: attrs.author_name,
      author_kind: attrs.author_kind,
      body: attrs.body,
      inserted_at: Calendar.strftime(DateTime.utc_now(), "%H:%M")
    }

    messages = Enum.take(state.messages ++ [message], -@maximum_messages)
    Phoenix.PubSub.broadcast(MatriarchUIDocs.PubSub, @message_topic, {:chat_message, message})
    {:reply, message, %{state | messages: messages, sequence: sequence}}
  end

  defp window_result(messages, offset, total) do
    %{
      messages: messages,
      offset: offset,
      total: total,
      has_older: offset > 0,
      has_newer: offset + length(messages) < total
    }
  end

  defp seeded_messages do
    names = [
      {"Mira", "mira", "person"},
      {"Theo", "theo", "person"},
      {"Matriarch AI", "matriarch-ai", "assistant"}
    ]

    bodies = [
      "Streams keep every message as an independent DOM node.",
      "The viewport only holds a bounded window of the conversation.",
      "Share the timestamp link to open this exact message.",
      "Presence can represent people, agents, or both.",
      "Scroll upward to move the server-side window through history.",
      "New messages arrive through PubSub without a database."
    ]

    Enum.map(1..180, fn index ->
      {name, author_id, kind} = Enum.at(names, rem(index - 1, length(names)))

      %ChatMessage{
        id: "message-#{index}",
        author_id: author_id,
        author_name: name,
        author_kind: kind,
        body: Enum.at(bodies, rem(index - 1, length(bodies))),
        inserted_at:
          "#{9 + div(index, 60)}:#{index |> rem(60) |> Integer.to_string() |> String.pad_leading(2, "0")}"
      }
    end)
  end
end
