defmodule MatriarchUI.Fieldset do
  @moduledoc "Native `<fieldset>`/`<legend>` grouping for a set of related `.field`s."
  use Phoenix.Component
  alias MatriarchUI.CN

  attr :class, :string, default: nil
  attr :rest, :global
  slot :legend
  slot :inner_block, required: true

  def fieldset(assigns) do
    ~H"""
    <fieldset data-mui class={CN.cn(["flex flex-col gap-4", @class])} {@rest}>
      <legend :if={@legend != []} class="mb-1 text-sm font-semibold text-mui-foreground">
        {render_slot(@legend)}
      </legend>
      {render_slot(@inner_block)}
    </fieldset>
    """
  end
end
