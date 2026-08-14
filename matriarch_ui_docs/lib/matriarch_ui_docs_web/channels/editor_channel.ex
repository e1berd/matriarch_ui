defmodule MatriarchUIDocsWeb.EditorChannel do
  @moduledoc "Relays Yjs document and awareness updates through Phoenix PubSub."
  use MatriarchUIDocsWeb, :channel

  alias MatriarchUIDocs.CollaborationStore
  alias MatriarchUIDocsWeb.EditorProtocol

  @max_awareness_bytes 64 * 1024

  @impl true
  def join("mui_editor:" <> document, %{"client_id" => client_id}, socket)
      when is_integer(client_id) do
    with true <- valid_document?(document),
         {:ok, state} <- CollaborationStore.open(document) do
      socket = assign(socket, document: document, client_id: client_id)
      {:ok, {:binary, EditorProtocol.encode_sync(state)}, socket}
    else
      false -> {:error, %{reason: "invalid_document"}}
      {:error, reason} -> {:error, %{reason: to_string(reason)}}
    end
  end

  def join("mui_editor:" <> _document, _params, _socket) do
    {:error, %{reason: "invalid_client"}}
  end

  @impl true
  def handle_in("update", {:binary, update}, socket) do
    case CollaborationStore.append(socket.assigns.document, update) do
      {:ok, version} ->
        broadcast_from!(socket, "update", {
          :binary,
          EditorProtocol.encode_update(version, update)
        })

        {:reply, {:ok, %{version: version}}, socket}

      {:error, reason} ->
        {:reply, {:error, %{reason: to_string(reason)}}, socket}
    end
  end

  def handle_in("compact", {:binary, payload}, socket) do
    with {:ok, version, snapshot} <- EditorProtocol.decode_compaction(payload),
         :ok <- CollaborationStore.compact(socket.assigns.document, version, snapshot) do
      {:reply, {:ok, %{}}, socket}
    else
      {:error, reason} -> {:reply, {:error, %{reason: to_string(reason)}}, socket}
    end
  end

  def handle_in("awareness", {:binary, update}, socket)
      when byte_size(update) <= @max_awareness_bytes do
    broadcast_from!(socket, "awareness", {:binary, update})
    {:noreply, socket}
  end

  def handle_in("awareness", {:binary, _update}, socket) do
    {:stop, :awareness_too_large, socket}
  end

  def handle_in("awareness_query", _payload, socket) do
    broadcast_from!(socket, "awareness_query", %{})
    {:noreply, socket}
  end

  @impl true
  def terminate(_reason, socket) do
    if document = socket.assigns[:document] do
      CollaborationStore.close(document)
      broadcast_from!(socket, "awareness_leave", %{client_id: socket.assigns.client_id})
    end

    :ok
  end

  defp valid_document?(document) do
    byte_size(document) in 1..128 and Regex.match?(~r/^[a-zA-Z0-9:_-]+$/, document)
  end
end
