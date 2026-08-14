defmodule MatriarchUIDocsWeb.EditorSocket do
  @moduledoc "Phoenix socket for collaborative rich editor documents."
  use Phoenix.Socket

  channel "mui_editor:*", MatriarchUIDocsWeb.EditorChannel
  channel "mui_draggable:*", MatriarchUIDocsWeb.DraggableChannel

  @impl true
  def connect(_params, socket, _connect_info), do: {:ok, socket}

  @impl true
  def id(_socket), do: nil
end
