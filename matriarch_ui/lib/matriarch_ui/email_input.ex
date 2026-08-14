defmodule MatriarchUI.EmailInput do
  @moduledoc "Email-specific input with form field binding and browser validation semantics."
  use Phoenix.Component
  import MatriarchUI.Input

  attr :field, Phoenix.HTML.FormField, default: nil
  attr :name, :any, default: nil
  attr :id, :any, default: nil
  attr :value, :any, default: nil
  attr :invalid, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(placeholder autocomplete disabled readonly required multiple)
  slot :leading

  def email_input(assigns) do
    ~H"""
    <.input
      field={@field}
      type="email"
      name={@name}
      id={@id}
      value={@value}
      invalid={@invalid}
      class={@class}
      {@rest}
    >
      <:leading :for={leading <- @leading}>{render_slot(leading)}</:leading>
    </.input>
    """
  end
end
