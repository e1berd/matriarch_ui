defmodule MatriarchUI.Radio do
  @moduledoc "Bare radio control for composition with `MatriarchUI.Field` and `field_label/1`."
  use Phoenix.Component
  alias MatriarchUI.CN

  attr :field, Phoenix.HTML.FormField
  attr :name, :any, default: nil
  attr :id, :any, default: nil
  attr :value, :any, default: "true"
  attr :checked, :boolean, default: nil
  attr :invalid, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled required)

  def radio(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(
      field: nil,
      name: assigns.name || field.name,
      id: assigns.id || field.id,
      checked:
        if(is_nil(assigns.checked),
          do: to_string(field.value) == to_string(assigns.value),
          else: assigns.checked
        ),
      invalid: used_input?(field) && field.errors != []
    )
    |> radio()
  end

  def radio(assigns) do
    assigns = assign(assigns, :checked, assigns.checked || false)

    ~H"""
    <span data-mui class={CN.cn(["relative inline-flex size-4 shrink-0", @class])}>
      <input
        type="radio"
        name={@name}
        id={@id}
        value={@value}
        checked={@checked}
        aria-invalid={to_string(@invalid)}
        class="peer absolute inset-0 z-10 m-0 cursor-pointer opacity-0 disabled:cursor-not-allowed"
        {@rest}
      />
      <span
        aria-hidden="true"
        class={[
          "flex size-4 items-center justify-center rounded-mui-full border border-mui-checkbox-border bg-mui-checkbox-background transition-colors",
          "peer-focus-visible:ring-2 peer-focus-visible:ring-mui-ring/30 peer-disabled:opacity-50",
          "peer-checked:border-mui-brand peer-checked:[&>span]:scale-100",
          @invalid && "border-mui-danger peer-focus-visible:ring-mui-danger/30"
        ]}
      >
        <span class="size-2 scale-0 rounded-mui-full bg-mui-brand transition-transform" />
      </span>
    </span>
    """
  end
end
