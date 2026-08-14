defmodule MatriarchUI.FileUpload do
  @moduledoc "Styled native file input with form field binding and selected-file feedback."
  use Phoenix.Component
  alias MatriarchUI.CN
  import MatriarchUI.Icon

  attr :field, Phoenix.HTML.FormField
  attr :name, :any, default: nil
  attr :id, :string, default: nil
  attr :invalid, :boolean, default: false
  attr :multiple, :boolean, default: false
  attr :prompt, :string, default: "Choose file"
  attr :empty_text, :string, default: "No file selected"
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
      class={CN.cn(["flex min-w-0 items-stretch", @class])}
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
        class={[
          "inline-flex h-8 shrink-0 cursor-pointer items-center gap-2 rounded-l-mui-md border border-mui-border bg-mui-surface px-3 text-sm font-medium text-mui-foreground hover:bg-mui-surface-hover",
          @invalid && "border-mui-danger"
        ]}
      >
        <.icon name="upload-simple" />
        {@prompt}
      </label>
      <span
        data-mui-file-name
        class={[
          "flex h-8 min-w-0 flex-1 items-center truncate rounded-r-mui-md border border-l-0 border-mui-border bg-mui-input-background px-3 text-sm text-mui-muted-foreground",
          @invalid && "border-mui-danger"
        ]}
      >
        {@empty_text}
      </span>
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
          const root = input.closest("[data-mui]")
          const name = root.querySelector("[data-mui-file-name]")
          const emptyText = name.textContent.trim()

          input.addEventListener("change", () => {
            const files = Array.from(input.files || [])
            name.textContent = files.length === 0 ? emptyText : files.map((file) => file.name).join(", ")
            name.classList.toggle("text-mui-muted-foreground", files.length === 0)
            name.classList.toggle("text-mui-foreground", files.length > 0)
          })
        }
      }
    </script>
    """
  end
end
