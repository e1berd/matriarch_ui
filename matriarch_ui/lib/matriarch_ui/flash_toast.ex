defmodule MatriarchUI.FlashToast do
  @moduledoc """
  Bridges server-rendered `Phoenix.Flash`/`put_flash/3` into `MatriarchUI.Toast`
  notifications, for apps that want flash messages to show as toasts instead
  of a banner. Mount one `<.toaster>` (from `MatriarchUI.Toast`) near the
  layout root, then render one `flash_toast` per kind you use:

      <.toaster id="toaster" />
      <.flash_toast flash={@flash} kind={:info} />
      <.flash_toast flash={@flash} kind={:error} />

  Each toast's id is derived from the flash message text, not fixed, because
  `auto_show` only fires the first time its DOM node mounts — a fixed id would
  stay inert on a second `put_flash/3` call for the same kind, since LiveView
  would patch the existing node in place instead of mounting a new one.

  Known limitation: dismissing by clicking the toast (including its close
  button) also clears the flash on the server, via the same `lv:clear-flash`
  event the classic `<.flash>` component uses. Dismissing by timeout does
  not — clearing the assign on a client-only timer needs a small hook
  listening for `mui:toast:dismissed` and pushing an event back, which this
  first version doesn't include. In practice this only means `@flash` holds
  onto the last message a little longer than the toast stays visible; a
  distinct next message still shows immediately (its id differs), so nothing
  gets stuck.
  """
  use Phoenix.Component
  import MatriarchUI.Toast
  alias Phoenix.LiveView.JS

  attr :flash, :map, required: true, doc: "the map of flash messages, e.g. @flash"
  attr :kind, :atom, values: [:info, :error], required: true

  attr :variant, :string,
    default: nil,
    doc: "defaults to \"info\"/\"danger\" from kind; see MatriarchUI.Toast for valid values"

  attr :title, :string, default: nil

  attr :position, :string,
    default: "top-right",
    values: ~w(top-left top-center top-right bottom-left bottom-center bottom-right)

  attr :duration, :integer, default: 5000

  def flash_toast(assigns) do
    assigns = assign(assigns, :msg, Phoenix.Flash.get(assigns.flash, assigns.kind))

    ~H"""
    <.toast
      :if={@msg}
      id={"flash-#{@kind}-#{:erlang.phash2(@msg)}"}
      variant={@variant || default_variant(@kind)}
      position={@position}
      duration={@duration}
      auto_show
      phx-click={JS.push("lv:clear-flash", value: %{key: @kind})}
    >
      <.toast_title :if={@title}>{@title}</.toast_title>
      {@msg}
    </.toast>
    """
  end

  defp default_variant(:info), do: "info"
  defp default_variant(:error), do: "danger"
end
