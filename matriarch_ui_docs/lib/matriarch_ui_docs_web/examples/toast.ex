defmodule MatriarchUIDocsWeb.Examples.Toast do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def search_content(_locale) do
    "toast sonner notification alert banner announcement position stack"
  end

  def examples(assigns) do
    ~H"""
    <div class="flex flex-col gap-8">
      <.toaster id="toast-demo-toaster" />

      <.example
        locale={@locale}
        title="Variants"
        description="Each toast is authored as a template near wherever it's triggered from, then shown by id."
        code={
          ~S'''
          <.button phx-click={MatriarchUI.Toast.show_toast("toast-default")}>Default</.button>
          <.toast id="toast-default">
            <.toast_title>Draft saved</.toast_title>
            <.toast_description>We'll keep this version for 30 days.</.toast_description>
          </.toast>

          <.button phx-click={MatriarchUI.Toast.show_toast("toast-info")} variant="outline">Info</.button>
          <.toast id="toast-info" variant="info">
            <.toast_title>New version available</.toast_title>
            <.toast_description>Reload to pick up the latest release.</.toast_description>
          </.toast>

          <.button phx-click={MatriarchUI.Toast.show_toast("toast-success")} variant="outline">
            Success
          </.button>
          <.toast id="toast-success" variant="success">
            <.toast_title>Payment received</.toast_title>
            <.toast_description>Invoice #4471 is now marked as paid.</.toast_description>
          </.toast>

          <.button phx-click={MatriarchUI.Toast.show_toast("toast-warning")} variant="outline">
            Warning
          </.button>
          <.toast id="toast-warning" variant="warning">
            <.toast_title>Session expiring</.toast_title>
            <.toast_description>You'll be signed out in 2 minutes.</.toast_description>
          </.toast>

          <.button phx-click={MatriarchUI.Toast.show_toast("toast-danger")} variant="outline">
            Danger, sticky
          </.button>
          <.toast id="toast-danger" variant="danger" duration={0}>
            <.toast_title>Upload failed</.toast_title>
            <.toast_description>The file exceeds the 25&nbsp;MB limit.</.toast_description>
          </.toast>
          '''
        }
      >
        <div class="flex flex-wrap gap-2">
          <.button phx-click={MatriarchUI.Toast.show_toast("toast-default")}>Default</.button>
          <.toast id="toast-default">
            <.toast_title>Draft saved</.toast_title>
            <.toast_description>We'll keep this version for 30 days.</.toast_description>
          </.toast>

          <.button phx-click={MatriarchUI.Toast.show_toast("toast-info")} variant="outline">Info</.button>
          <.toast id="toast-info" variant="info">
            <.toast_title>New version available</.toast_title>
            <.toast_description>Reload to pick up the latest release.</.toast_description>
          </.toast>

          <.button phx-click={MatriarchUI.Toast.show_toast("toast-success")} variant="outline">
            Success
          </.button>
          <.toast id="toast-success" variant="success">
            <.toast_title>Payment received</.toast_title>
            <.toast_description>Invoice #4471 is now marked as paid.</.toast_description>
          </.toast>

          <.button phx-click={MatriarchUI.Toast.show_toast("toast-warning")} variant="outline">
            Warning
          </.button>
          <.toast id="toast-warning" variant="warning">
            <.toast_title>Session expiring</.toast_title>
            <.toast_description>You'll be signed out in 2 minutes.</.toast_description>
          </.toast>

          <.button phx-click={MatriarchUI.Toast.show_toast("toast-danger")} variant="outline">
            Danger, sticky
          </.button>
          <.toast id="toast-danger" variant="danger" duration={0}>
            <.toast_title>Upload failed</.toast_title>
            <.toast_description>The file exceeds the 25&nbsp;MB limit.</.toast_description>
          </.toast>
        </div>
      </.example>

      <.example
        locale={@locale}
        title="Any corner of the screen"
        description="Each toast picks its own position — unrelated notifications can stack in different corners at once."
        code={
          ~S'''
          <.button phx-click={MatriarchUI.Toast.show_toast("toast-top-left")}>Top left</.button>
          <.toast id="toast-top-left" position="top-left">
            <.toast_title>Top left</.toast_title>
          </.toast>
          '''
        }
      >
        <div class="grid grid-cols-3 gap-2">
          <.button
            :for={
              {position, label} <- [
                {"top-left", "Top left"},
                {"top-center", "Top center"},
                {"top-right", "Top right"},
                {"bottom-left", "Bottom left"},
                {"bottom-center", "Bottom center"},
                {"bottom-right", "Bottom right"}
              ]
            }
            variant="outline"
            phx-click={MatriarchUI.Toast.show_toast("toast-#{position}")}
          >
            {label}
          </.button>
          <.toast
            :for={
              {position, label} <- [
                {"top-left", "Top left"},
                {"top-center", "Top center"},
                {"top-right", "Top right"},
                {"bottom-left", "Bottom left"},
                {"bottom-center", "Bottom center"},
                {"bottom-right", "Bottom right"}
              ]
            }
            id={"toast-#{position}"}
            position={position}
          >
            <.toast_title>{label}</.toast_title>
          </.toast>
        </div>
      </.example>

      <.example
        locale={@locale}
        title="Custom content"
        description="Beyond title/description, a toast slot accepts anything — avatars, buttons, forms."
        code={
          ~S'''
          <.toast id="toast-invite" position="top-right" duration={0}>
            <div class="flex items-start gap-3">
              <.avatar initials="MI" size="sm" />
              <div>
                <p class="font-medium text-mui-foreground">Mira invited you to Deployment actions</p>
                <div class="mt-2 flex gap-2">
                  <.button size="sm" variant="brand" phx-click={MatriarchUI.Toast.dismiss_toast("toast-invite")}>
                    Accept
                  </.button>
                  <.button size="sm" variant="ghost" phx-click={MatriarchUI.Toast.dismiss_toast("toast-invite")}>
                    Decline
                  </.button>
                </div>
              </div>
            </div>
          </.toast>
          '''
        }
      >
        <.button phx-click={MatriarchUI.Toast.show_toast("toast-invite")}>Invite to project</.button>
        <.toast id="toast-invite" position="top-right" duration={0}>
          <div class="flex items-start gap-3">
            <.avatar initials="MI" size="sm" />
            <div>
              <p class="font-medium text-mui-foreground">Mira invited you to Deployment actions</p>
              <div class="mt-2 flex gap-2">
                <.button
                  size="sm"
                  variant="brand"
                  phx-click={MatriarchUI.Toast.dismiss_toast("toast-invite")}
                >
                  Accept
                </.button>
                <.button
                  size="sm"
                  variant="ghost"
                  phx-click={MatriarchUI.Toast.dismiss_toast("toast-invite")}
                >
                  Decline
                </.button>
              </div>
            </div>
          </div>
        </.toast>
      </.example>

      <.props_table
        locale={@locale}
        rows={[
          {"toaster.id", "string", "mount once near the layout root; defaults to \"toaster\""},
          {"toast.id", "string, required", "target for show/1, dismiss/1, and auto_show dedup"},
          {"toast.position", "string",
           "top-left | top-center | top-right | bottom-left | bottom-center | bottom-right"},
          {"toast.variant", "default | info | success | warning | danger",
           "picks the leading icon and its color"},
          {"toast.duration", "integer", "auto-dismiss delay in ms; 0 keeps it until dismissed"},
          {"toast.dismissible", "boolean", "shows the close button; defaults to true"},
          {"toast.auto_show", "boolean",
           "shows itself as soon as it mounts — for streamed, server-driven toasts"},
          {"MatriarchUI.Toast.show_toast(id)", "JS command",
           "clones and animates the toast into its region"},
          {"MatriarchUI.Toast.dismiss_toast(id)", "JS command", "animates a visible toast out early"}
        ]}
      />
    </div>
    """
  end
end
