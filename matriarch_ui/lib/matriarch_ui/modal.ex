defmodule MatriarchUI.Modal do
  @moduledoc """
  Native `<dialog>`-backed modal — focus-trap, ESC-to-close and the backdrop
  come from the browser for free. Open/close from anywhere with:

      phx-click={MatriarchUI.Modal.show_modal("my-modal")}
      phx-click={MatriarchUI.Modal.hide_modal("my-modal")}
  """
  use Phoenix.Component
  alias MatriarchUI.CN
  alias Phoenix.LiveView.JS

  attr :id, :string, required: true
  attr :title, :string, default: nil
  attr :class, :string, default: nil
  slot :inner_block, required: true
  slot :footer

  def modal(assigns) do
    ~H"""
    <dialog
      id={@id}
      phx-hook=".MUIDialog"
      class={
        CN.cn([
          "m-auto hidden max-h-[85vh] w-full max-w-md flex-col overflow-hidden rounded-mui-xl",
          "border border-mui-border bg-mui-surface p-0 text-mui-foreground shadow-mui-xl",
          "backdrop:bg-mui-overlay open:flex",
          @class
        ])
      }
    >
      <div class="flex items-start justify-between gap-4 border-b border-mui-border px-4 py-3.5">
        <h2 :if={@title} class="text-base font-semibold text-mui-foreground">{@title}</h2>
        <button
          type="button"
          phx-click={hide_modal(@id)}
          class="text-mui-subtle-foreground hover:text-mui-foreground"
          aria-label="Close"
        >
          <svg class="size-5" viewBox="0 0 20 20" fill="none" aria-hidden="true">
            <path
              d="M5 5l10 10M15 5L5 15"
              stroke="currentColor"
              stroke-width="1.5"
              stroke-linecap="round"
            />
          </svg>
        </button>
      </div>
      <div class="overflow-auto px-4 py-3.5 text-sm">{render_slot(@inner_block)}</div>
      <div :if={@footer != []} class="flex justify-end gap-2 border-t border-mui-border px-4 py-3.5">
        {render_slot(@footer)}
      </div>
    </dialog>
    """
  end

  def show_modal(id), do: JS.dispatch("mui:open", to: "##{id}")
  def hide_modal(id), do: JS.dispatch("mui:close", to: "##{id}")

  attr :rest, :global

  def hook(assigns) do
    ~H"""
    <script :type={Phoenix.LiveView.ColocatedHook} name=".MUIDialog">
      export default {
        mounted() {
          const dialog = this.el

          const open = () => {
            dialog.showModal()
            document.body.style.overflow = "hidden"
          }

          dialog.addEventListener("mui:open", open)
          dialog.addEventListener("mui:close", () => dialog.close())
          dialog.addEventListener("close", () => document.body.style.removeProperty("overflow"))
          dialog.addEventListener("click", (event) => {
            if (event.target === dialog) dialog.close()
          })
        }
      }
    </script>
    """
  end
end
