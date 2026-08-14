defmodule MatriarchUI.Autocomplete do
  @moduledoc """
  Searchable text input with a client-filtered floating listbox, anchored
  via `.MUIFloating` — pair with `MatriarchUI.Field` for a label and
  validation errors. The input's own value is the form field — pass an
  optionally filtered `:option` list (e.g. from your own `phx-change`/
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
        data-mui-filter="true"
        data-mui-match-width="true"
        class={
          CN.cn([
            "mui-input h-8 w-full rounded-mui-md border border-transparent bg-mui-input-background px-3 text-sm text-mui-foreground",
            "placeholder:text-mui-input-placeholder focus-visible:border-mui-brand focus-visible:ring-2 focus-visible:ring-mui-slider-ring",
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
            "max-h-64 overflow-auto rounded-mui-md border border-mui-border bg-mui-surface p-1 text-sm shadow-mui-lg"
          ])
        }
      >
        <div
          :for={option <- @option}
          role="option"
          tabindex="-1"
          data-mui-value={option.value}
          data-mui-label={option[:label] || option.value}
          class="flex cursor-pointer items-center justify-between rounded-mui-sm px-2 py-2 hover:bg-mui-surface-hover focus:bg-mui-surface-hover focus:outline-none"
        >
          {render_slot(option)}
        </div>
        <p data-mui-empty hidden={@option != []} class="px-2 py-2 text-mui-subtle-foreground">
          No results
        </p>
      </div>
    </div>
    """
  end
end
