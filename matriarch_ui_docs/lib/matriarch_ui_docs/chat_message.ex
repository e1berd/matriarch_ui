defmodule MatriarchUIDocs.ChatMessage do
  @moduledoc "Ephemeral message used by the public chat example."

  @enforce_keys [:id, :author_id, :author_name, :author_kind, :body, :inserted_at]
  defstruct [:id, :author_id, :author_name, :author_kind, :body, :inserted_at]
end
