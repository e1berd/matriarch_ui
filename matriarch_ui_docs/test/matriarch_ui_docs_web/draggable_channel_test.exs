defmodule MatriarchUIDocsWeb.DraggableChannelTest do
  use ExUnit.Case, async: false
  import Phoenix.ChannelTest

  alias MatriarchUIDocs.DraggableStore
  alias MatriarchUIDocsWeb.EditorSocket

  @endpoint MatriarchUIDocsWeb.Endpoint

  setup do
    document = "drag-#{System.unique_integer([:positive])}"
    on_exit(fn -> DraggableStore.reset(document) end)
    {:ok, socket} = connect(EditorSocket, %{})
    %{document: document, socket: socket}
  end

  test "joins with the first client order", %{document: document, socket: socket} do
    assert {:ok, %{order: ["one", "two"], version: 0}, _socket} =
             subscribe_and_join(socket, "mui_draggable:#{document}", %{
               "order" => ["one", "two"]
             })
  end

  test "persists and broadcasts realtime order", %{document: document} do
    {:ok, first_socket} = connect(EditorSocket, %{})
    {:ok, second_socket} = connect(EditorSocket, %{})

    {:ok, _state, first_socket} =
      subscribe_and_join(first_socket, "mui_draggable:#{document}", %{
        "order" => ["one", "two", "three"]
      })

    {:ok, _state, _second_socket} =
      subscribe_and_join(second_socket, "mui_draggable:#{document}", %{
        "order" => ["one", "two", "three"]
      })

    ref = push(first_socket, "reorder", %{"order" => ["three", "one", "two"]})

    assert_reply(ref, :ok, %{order: ["three", "one", "two"], version: 1})
    assert_broadcast("order", %{order: ["three", "one", "two"], version: 1})

    {:ok, joining_socket} = connect(EditorSocket, %{})

    assert {:ok, %{order: ["three", "one", "two"], version: 1}, _socket} =
             subscribe_and_join(joining_socket, "mui_draggable:#{document}", %{
               "order" => ["one", "two", "three"]
             })
  end

  test "rejects a changed item set", %{document: document, socket: socket} do
    {:ok, _state, socket} =
      subscribe_and_join(socket, "mui_draggable:#{document}", %{
        "order" => ["one", "two"]
      })

    ref = push(socket, "reorder", %{"order" => ["one", "other"]})
    assert_reply(ref, :error, %{reason: "invalid_order"})

    {:ok, joining_socket} = connect(EditorSocket, %{})

    assert {:error, %{reason: "invalid_order"}} =
             subscribe_and_join(joining_socket, "mui_draggable:#{document}", %{
               "order" => ["one", "other"]
             })
  end

  test "rejects duplicate ids and invalid document names", %{socket: socket} do
    assert {:error, %{reason: "invalid_order"}} =
             subscribe_and_join(socket, "mui_draggable:valid", %{
               "order" => ["same", "same"]
             })

    {:ok, another_socket} = connect(EditorSocket, %{})

    assert {:error, %{reason: "invalid_document"}} =
             subscribe_and_join(another_socket, "mui_draggable:not allowed", %{
               "order" => ["one"]
             })
  end
end
