defmodule MatriarchUI.FileUpload do
  @moduledoc "File picker and drop zone that emits selection events without rendering file state."
  use Phoenix.Component
  alias MatriarchUI.CN
  import MatriarchUI.Icon

  attr :field, Phoenix.HTML.FormField
  attr :name, :any, default: nil
  attr :id, :string, default: nil
  attr :invalid, :boolean, default: false
  attr :multiple, :boolean, default: false
  attr :prompt, :string, default: "Choose file"
  attr :description, :string, default: "or drop it here"
  attr :event, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(accept capture disabled required)

  def file_upload(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(
      field: nil,
      invalid: used_input?(field) && field.errors != [],
      name: assigns.name || field.name,
      id: assigns.id || field.id
    )
    |> file_upload()
  end

  def file_upload(assigns) do
    ~H"""
    <div
      id={"#{@id}-upload"}
      data-mui
      data-mui-file-upload
      data-mui-upload-event={@event}
      data-mui-disabled={to_string(@rest[:disabled] || false)}
      class={CN.cn(["w-full", @class])}
    >
      <input
        type="file"
        id={@id}
        phx-hook=".MUIFileUpload"
        name={multiple_name(@name, @multiple)}
        multiple={@multiple}
        aria-invalid={to_string(@invalid)}
        data-mui-file-input
        class="sr-only"
        {@rest}
      />
      <label
        for={@id}
        data-mui-control
        data-mui-file-dropzone
        data-mui-state="idle"
        class={[
          "flex min-h-24 w-full cursor-pointer flex-col items-center justify-center gap-1 rounded-mui-md border border-dashed border-mui-border bg-mui-input-background px-4 py-3 text-center",
          "hover:border-mui-brand hover:bg-mui-surface-hover data-[mui-state=dragging]:border-mui-brand data-[mui-state=dragging]:bg-mui-primary-subtle",
          "has-[:focus-visible]:border-mui-brand has-[:focus-visible]:ring-2 has-[:focus-visible]:ring-mui-slider-ring",
          @rest[:disabled] && "pointer-events-none cursor-not-allowed opacity-50",
          @invalid && "border-mui-danger"
        ]}
      >
        <.icon name="upload-simple" class="mb-1 size-5 text-mui-muted-foreground" />
        <span class="text-sm font-medium text-mui-foreground">{@prompt}</span>
        <span :if={@description} class="text-xs text-mui-muted-foreground">{@description}</span>
      </label>
    </div>
    """
  end

  defp multiple_name(nil, _multiple), do: nil
  defp multiple_name(name, false), do: name

  defp multiple_name(name, true) do
    name = to_string(name)
    if String.ends_with?(name, "[]"), do: name, else: "#{name}[]"
  end

  attr :rest, :global

  def hook(assigns) do
    ~H"""
    <script :type={Phoenix.LiveView.ColocatedHook} name=".MUIFileUpload">
      export default {
        mounted() {
          const input = this.el
          const root = input.closest("[data-mui-file-upload]")
          const dropzone = root.querySelector("[data-mui-file-dropzone]")
          const abort = new AbortController()
          const signal = abort.signal

          const filesPayload = () => Array.from(input.files || []).map((file) => ({
            name: file.name,
            size: file.size,
            type: file.type,
            last_modified: file.lastModified
          }))

          const emit = () => {
            const files = filesPayload()
            root.dispatchEvent(new CustomEvent("mui:file-upload", {
              bubbles: true,
              detail: { files }
            }))
            if (root.dataset.muiUploadEvent) {
              this.pushEvent(root.dataset.muiUploadEvent, { files })
            }
          }

          const idle = () => { dropzone.dataset.muiState = "idle" }

          dropzone.addEventListener("dragenter", (event) => {
            event.preventDefault()
            if (root.dataset.muiDisabled !== "true") dropzone.dataset.muiState = "dragging"
          }, { signal })

          dropzone.addEventListener("dragover", (event) => {
            event.preventDefault()
            if (event.dataTransfer) event.dataTransfer.dropEffect = "copy"
          }, { signal })

          dropzone.addEventListener("dragleave", (event) => {
            if (!dropzone.contains(event.relatedTarget)) idle()
          }, { signal })

          dropzone.addEventListener("drop", (event) => {
            event.preventDefault()
            idle()
            if (root.dataset.muiDisabled === "true" || !event.dataTransfer) return
            const transfer = new DataTransfer()
            const files = Array.from(event.dataTransfer.files)
            const accepted = input.multiple ? files : files.slice(0, 1)
            accepted.forEach((file) => transfer.items.add(file))
            input.files = transfer.files
            input.dispatchEvent(new Event("input", { bubbles: true }))
            input.dispatchEvent(new Event("change", { bubbles: true }))
          }, { signal })

          input.addEventListener("change", emit, { signal })
          this.muiAbort = abort
        },
        destroyed() {
          if (this.muiAbort) this.muiAbort.abort()
        }
      }
    </script>
    """
  end
end
