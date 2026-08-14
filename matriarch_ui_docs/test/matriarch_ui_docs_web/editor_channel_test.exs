defmodule MatriarchUIDocsWeb.EditorChannelTest do
  use ExUnit.Case, async: false
  import Phoenix.ChannelTest

  alias MatriarchUIDocs.CollaborationStore
  alias MatriarchUIDocsWeb.EditorProtocol
  alias MatriarchUIDocsWeb.EditorSocket

  @endpoint MatriarchUIDocsWeb.Endpoint

  setup do
    document = "test-#{System.unique_integer([:positive])}"
    on_exit(fn -> CollaborationStore.reset(document) end)
    {:ok, socket} = connect(EditorSocket, %{})
    %{document: document, socket: socket}
  end

  test "joins with an empty binary Yjs sync packet", %{document: document, socket: socket} do
    assert {:ok, {:binary, packet}, _socket} =
             subscribe_and_join(socket, "mui_editor:#{document}", %{"client_id" => 101})

    assert <<0::unsigned-big-64, 0::unsigned-big-32, 0::unsigned-big-32>> = packet
  end

  test "persists and broadcasts binary document updates", %{document: document} do
    {:ok, first_socket} = connect(EditorSocket, %{})
    {:ok, second_socket} = connect(EditorSocket, %{})

    {:ok, _packet, first_socket} =
      subscribe_and_join(first_socket, "mui_editor:#{document}", %{"client_id" => 101})

    {:ok, _packet, _second_socket} =
      subscribe_and_join(second_socket, "mui_editor:#{document}", %{"client_id" => 202})

    update = <<1, 2, 3, 4>>
    ref = push(first_socket, "update", {:binary, update})

    assert_reply ref, :ok, %{version: 1}
    assert_broadcast "update", {:binary, <<1::unsigned-big-64, ^update::binary>>}

    {:ok, joining_socket} = connect(EditorSocket, %{})

    assert {:ok, {:binary, sync}, _joining_socket} =
             subscribe_and_join(joining_socket, "mui_editor:#{document}", %{
               "client_id" => 303
             })

    assert <<1::unsigned-big-64, 0::unsigned-big-32, 1::unsigned-big-32, 4::unsigned-big-32,
             ^update::binary>> = sync
  end

  test "compacts only the current document version", %{document: document, socket: socket} do
    {:ok, _packet, socket} =
      subscribe_and_join(socket, "mui_editor:#{document}", %{"client_id" => 101})

    update_ref = push(socket, "update", {:binary, <<1, 2, 3>>})
    assert_reply update_ref, :ok, %{version: 1}

    stale_ref = push(socket, "compact", {:binary, <<0::unsigned-big-64, 9, 9>>})
    assert_reply stale_ref, :error, %{reason: "stale"}

    compact_ref = push(socket, "compact", {:binary, <<1::unsigned-big-64, 9, 9>>})
    assert_reply compact_ref, :ok, %{}

    assert {:ok, %{snapshot: <<9, 9>>, updates: [], version: 1}} =
             CollaborationStore.open(document)
  end

  test "broadcasts ephemeral awareness without storing it", %{document: document} do
    {:ok, first_socket} = connect(EditorSocket, %{})
    {:ok, second_socket} = connect(EditorSocket, %{})

    {:ok, _packet, first_socket} =
      subscribe_and_join(first_socket, "mui_editor:#{document}", %{"client_id" => 101})

    {:ok, _packet, _second_socket} =
      subscribe_and_join(second_socket, "mui_editor:#{document}", %{"client_id" => 202})

    push(first_socket, "awareness", {:binary, <<4, 5, 6>>})
    assert_broadcast "awareness", {:binary, <<4, 5, 6>>}
  end

  test "rejects invalid document names", %{socket: socket} do
    assert {:error, %{reason: "invalid_document"}} =
             subscribe_and_join(socket, "mui_editor:not allowed", %{"client_id" => 101})
  end

  test "encodes sync and compaction packets" do
    packet = EditorProtocol.encode_sync(%{version: 4, snapshot: <<1, 2>>, updates: [<<3>>]})

    assert <<4::unsigned-big-64, 2::unsigned-big-32, 1, 2, 1::unsigned-big-32, 1::unsigned-big-32,
             3>> = packet

    assert {:ok, 4, <<7, 8>>} =
             EditorProtocol.decode_compaction(<<4::unsigned-big-64, 7, 8>>)
  end
end
