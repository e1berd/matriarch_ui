defmodule MatriarchUI.Autocomplete do
  @moduledoc """
  Bare text input with a filtered floating listbox of suggestions, anchored
  via `.MUIFloating` — pair with `MatriarchUI.Field` for a label and
  validation errors. The input's own value is the form field — pass an
  already filtered `:option` list (e.g. from your own `phx-change`/
  `phx-debounce` handler); picking one fills the input with that option's text.
  """
  use Phoenix.Component
  alias MatriarchUI.{CN, Floating}

  attr :id, :string, required: true
  attr :field, Phoenix.HTML.FormField
  attr :name, :any, default: nil
  attr :value, :any, default: nil
  attr :placeholder, :string, default: "Search…"
  attr :invalid, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(phx-change phx-keyup phx-debounce phx-target disabled)

  slot :option do
    attr :value, :string, required: true
    attr :label, :string, doc: "plain-text mirror written into the input on pick"
  end

  def autocomplete(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, invalid: used_input?(field) && field.errors != [])
    |> assign_new(:name, fn -> field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> autocomplete()
  end

  def autocomplete(assigns) do
    ~H"""
    <div data-mui>
      <input
        type="text"
        id={@id}
        name={@name}
        value={@value}
        placeholder={@placeholder}
        autocomplete="off"
        phx-hook="MatriarchUI.Floating.MUIFloating"
        aria-controls={"#{@id}-panel"}
        aria-haspopup="listbox"
        aria-expanded="false"
        aria-invalid={to_string(@invalid)}
        data-mui-trigger="focus"
        data-mui-placement="bottom-start"
        data-mui-axis="vertical"
        data-mui-role="listbox"
        class={
          CN.cn([
            "h-9 w-full rounded-mui-sm border border-mui-border-strong bg-mui-surface px-3 text-sm text-mui-foreground shadow-mui-xs",
            "placeholder:text-mui-subtle-foreground focus-visible:border-mui-primary focus-visible:ring-2 focus-visible:ring-mui-ring/20",
            @invalid && "border-mui-danger focus-visible:ring-mui-danger/30",
            @class
          ])
        }
        {@rest}
      />
      <div
        id={"#{@id}-panel"}
        role="listbox"
        data-mui-state="closed"
        class={
          CN.cn([
            Floating.panel_class(),
            "max-h-64 min-w-48 overflow-auto rounded-mui-lg border border-mui-border bg-mui-surface p-1 text-sm shadow-mui-lg"
          ])
        }
      >
        <div
          :for={option <- @option}
          role="option"
          tabindex="-1"
          data-mui-value={option.value}
          data-mui-label={option[:label] || option.value}
          class="flex cursor-pointer items-center justify-between rounded-mui-sm px-2.5 py-1.5 hover:bg-mui-surface-hover"
        >
          {render_slot(option)}
        </div>
        <p :if={@option == []} class="px-2.5 py-1.5 text-mui-subtle-foreground">No results</p>
      </div>
    </div>
    """
  end
end
