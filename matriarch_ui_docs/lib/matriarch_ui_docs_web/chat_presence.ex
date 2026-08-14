defmodule MatriarchUIDocsWeb.ChatPresence do
  @moduledoc "Presence-backed participants and typing state for the chat example."
  alias MatriarchUIDocsWeb.Presence
  alias Phoenix.LiveView

  @topic "docs_chat:presence"
  @names ~w(Ada Grace Lin Alan Hedy Claude Barbara Donald Margaret)

  def topic, do: @topic

  def identity(socket) do
    id = socket.id || "visitor-preview"
    index = :erlang.phash2(id, length(@names))
    %{id: id, name: Enum.at(@names, index), kind: "person"}
  end

  def track(socket, identity) do
    if LiveView.connected?(socket) do
      Phoenix.PubSub.subscribe(MatriarchUIDocs.PubSub, @topic)

      {:ok, _ref} =
        Presence.track(self(), @topic, identity.id, %{
          name: identity.name,
          kind: identity.kind,
          typing: false
        })
    end

    snapshot(identity.id)
  end

  def set_typing(identity, typing?) do
    Presence.update(self(), @topic, identity.id, %{
      name: identity.name,
      kind: identity.kind,
      typing: typing?
    })
  end

  def snapshot(own_id) do
    participants =
      @topic
      |> Presence.list()
      |> Enum.flat_map(fn {id, presence} ->
        Enum.map(presence.metas, &Map.put(&1, :id, id))
      end)

    %{
      online_count: length(participants),
      typing: Enum.filter(participants, &(&1.id != own_id && &1.typing))
    }
  end

  def diff?(%{topic: @topic, event: "presence_diff"}), do: true
  def diff?(_message), do: false
end
