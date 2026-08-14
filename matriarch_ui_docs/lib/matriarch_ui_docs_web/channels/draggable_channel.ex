defmodule MatriarchUIDocsWeb.DraggableChannel do
  @moduledoc "Synchronizes draggable item order through Phoenix PubSub."
  use MatriarchUIDocsWeb, :channel

  alias MatriarchUIDocs.DraggableStore

  @max_items 256
  @max_item_bytes 128

  @impl true
  def join("mui_draggable:" <> document, %{"order" => order}, socket) do
    with :ok <- validate_document(document),
         :ok <- validate_order(order),
         {:ok, state} <- DraggableStore.open(document, order) do
      {:ok, state, assign(socket, :document, document)}
    else
      {:error, reason} -> {:error, %{reason: to_string(reason)}}
    end
  end

  def join("mui_draggable:" <> _document, _params, _socket) do
    {:error, %{reason: "invalid_order"}}
  end

  @impl true
  def handle_in("reorder", %{"order" => order}, socket) do
    with :ok <- validate_order(order),
         {:ok, version} <- DraggableStore.reorder(socket.assigns.document, order) do
      payload = %{order: order, version: version}
      broadcast_from!(socket, "order", payload)
      {:reply, {:ok, payload}, socket}
    else
      {:error, reason} -> {:reply, {:error, %{reason: to_string(reason)}}, socket}
    end
  end

  @impl true
  def terminate(_reason, socket) do
    if document = Map.get(socket.assigns, :document) do
      DraggableStore.close(document)
    end

    :ok
  end

  defp validate_document(document) do
    if byte_size(document) in 1..128 and Regex.match?(~r/^[a-zA-Z0-9:_-]+$/, document) do
      :ok
    else
      {:error, :invalid_document}
    end
  end

  defp validate_order(order) when is_list(order) and length(order) in 1..@max_items do
    if Enum.all?(order, &(is_binary(&1) and byte_size(&1) in 1..@max_item_bytes)) and
         MapSet.size(MapSet.new(order)) == length(order) do
      :ok
    else
      {:error, :invalid_order}
    end
  end

  defp validate_order(_order), do: {:error, :invalid_order}
end
