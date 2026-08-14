defmodule MatriarchUI.Field do
  @moduledoc """
  Generates one id and hands it to its content via `:let` — compose a
  `field_label/1` and a bare control (`.input`, `.checkbox`, ...) in whatever
  order and layout you want, the label's `for` and the control's `id` can
  never drift apart because they're the same value:

      <.field id="name" :let={id}>
        <.field_label for={id}>Name</.field_label>
        <.input id={id} name="name" placeholder="John Doe" />
      </.field>

      <.field id="accept" orientation="horizontal" :let={id}>
        <.checkbox id={id} name="accept" />
        <.field_label for={id}>Accept terms</.field_label>
      </.field>

  Default layout is a vertical stack (label above or below the control,
  depending on which you write first). Set `orientation="horizontal"` for
  a horizontal row. Pass
  `field={@form[:name]}` instead of `id` to also derive the id and the
  field's own validation errors from a `Phoenix.HTML.FormField`.
  """
  use Phoenix.Component
  alias MatriarchUI.CN

  attr :id, :string, default: nil
  attr :field, Phoenix.HTML.FormField
  attr :errors, :list, default: []
  attr :orientation, :string, default: "vertical", values: ~w(horizontal vertical)
  attr :class, :string, default: nil
  slot :inner_block, required: true

  def field(%{field: %Phoenix.HTML.FormField{} = form_field} = assigns) do
    errors = if used_input?(form_field), do: form_field.errors, else: []

    assigns
    |> assign(field: nil, errors: Enum.map(errors, &translate/1))
    |> assign_new(:id, fn -> form_field.id end)
    |> field()
  end

  def field(assigns) do
    ~H"""
    <div
      data-mui
      data-mui-orientation={@orientation}
      class={
        CN.cn([
          "flex",
          @orientation == "vertical" && "flex-col gap-1.5",
          @orientation == "horizontal" && "flex-row items-center gap-2",
          @class
        ])
      }
    >
      {render_slot(@inner_block, @id)}
      <p :for={error <- @errors} class="text-sm text-mui-danger">{error}</p>
    </div>
    """
  end

  attr :for, :string, required: true
  attr :class, :string, default: nil
  slot :inner_block, required: true

  def field_label(assigns) do
    ~H"""
    <label for={@for} class={CN.cn(["text-sm font-medium text-mui-foreground", @class])}>
      {render_slot(@inner_block)}
    </label>
    """
  end

  defp translate({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end

  defp translate(msg), do: msg
end
