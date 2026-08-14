defmodule MatriarchUIDocsWeb.EditorProtocol do
  @moduledoc "Binary framing for Yjs document synchronization over Phoenix Channels."

  def encode_sync(%{version: version, snapshot: snapshot, updates: updates}) do
    encoded_updates = Enum.map(updates, &encode_sized/1)

    IO.iodata_to_binary([
      <<version::unsigned-big-64, byte_size(snapshot)::unsigned-big-32>>,
      snapshot,
      <<length(updates)::unsigned-big-32>>,
      encoded_updates
    ])
  end

  def encode_update(version, update), do: <<version::unsigned-big-64, update::binary>>

  def decode_compaction(<<version::unsigned-big-64, snapshot::binary>>) when snapshot != <<>> do
    {:ok, version, snapshot}
  end

  def decode_compaction(_payload), do: {:error, :invalid_compaction}

  defp encode_sized(update), do: [<<byte_size(update)::unsigned-big-32>>, update]
end
