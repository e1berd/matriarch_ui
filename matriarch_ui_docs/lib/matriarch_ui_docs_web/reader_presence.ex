defmodule MatriarchUIDocsWeb.ReaderPresence do
  @moduledoc "Tracks how many connected viewers are currently on a given docs page."

  alias MatriarchUIDocsWeb.Presence
  alias Phoenix.LiveView

  def topic(page_id), do: "docs_readers:#{page_id}"

  def track(socket, page_id) do
    topic = topic(page_id)

    if LiveView.connected?(socket) do
      Phoenix.PubSub.subscribe(MatriarchUIDocs.PubSub, topic)
      {:ok, _ref} = Presence.track(self(), topic, socket.id, %{})
    end

    {topic, count(topic)}
  end

  def count(topic), do: topic |> Presence.list() |> map_size()

  def diff?(topic, %{topic: topic, event: "presence_diff"}), do: true
  def diff?(_topic, _message), do: false
end
