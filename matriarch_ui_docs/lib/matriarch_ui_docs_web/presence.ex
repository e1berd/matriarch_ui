defmodule MatriarchUIDocsWeb.Presence do
  use Phoenix.Presence,
    otp_app: :matriarch_ui_docs,
    pubsub_server: MatriarchUIDocs.PubSub
end
