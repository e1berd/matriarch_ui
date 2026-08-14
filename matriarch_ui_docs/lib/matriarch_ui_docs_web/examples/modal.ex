defmodule MatriarchUIDocsWeb.Examples.Modal do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      locale={@locale}
      title="Basic"
      code={
        ~S'''
        <.button phx-click={MatriarchUI.Modal.show_modal("confirm")}>Delete account</.button>

        <.modal id="confirm" title="Delete account?">
          This cannot be undone.
          <:footer>
            <.button variant="outline" phx-click={MatriarchUI.Modal.hide_modal("confirm")}>
              Cancel
            </.button>
            <.button variant="destructive" phx-click={MatriarchUI.Modal.hide_modal("confirm")}>
              Delete
            </.button>
          </:footer>
        </.modal>
        '''
      }
    >
      <.button phx-click={MatriarchUI.Modal.show_modal("confirm")}>Delete account</.button>

      <.modal id="confirm" title="Delete account?">
        This cannot be undone.
        <:footer>
          <.button variant="outline" phx-click={MatriarchUI.Modal.hide_modal("confirm")}>
            Cancel
          </.button>
          <.button variant="destructive" phx-click={MatriarchUI.Modal.hide_modal("confirm")}>
            Delete
          </.button>
        </:footer>
      </.modal>
    </.example>

    <.props_table
      locale={@locale}
      rows={[
        {"id", "string, required", "id passed to show_modal/1 and hide_modal/1"},
        {"title", "string", "optional header text"},
        {"footer", "slot", "optional footer, usually action buttons"}
      ]}
    />
    """
  end
end
