defmodule MatriarchUI.Select do
  @moduledoc "Bare listbox-style select — pair with `MatriarchUI.Field` for a label and validation errors."
  use Phoenix.Component
  alias MatriarchUI.{CN, Floating}

  attr :id, :string, required: true
  attr :field, Phoenix.HTML.FormField
  attr :name, :any, default: nil
  attr :value, :any, default: nil
  attr :placeholder, :string, default: "Select…"
  attr :invalid, :boolean, default: false
  attr :class, :string, default: nil

  slot :option, required: true do
    attr :value, :string, required: true
    attr :label, :string, doc: "plain-text mirror shown in the trigger after a client-side pick"
  end

  def select(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, invalid: used_input?(field) && field.errors != [])
    |> assign_new(:name, fn -> field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> select()
  end

  def select(assigns) do
    assigns =
      assign(
        assigns,
        :selected,
        Enum.find(assigns.option, &(to_string(&1.value) == to_string(assigns.value)))
      )

    ~H"""
    <div data-mui>
      <input type="hidden" id={"#{@id}-value"} name={@name} value={@value} />
      <button
        type="button"
        id={@id}
        phx-hook="MatriarchUI.Floating.MUIFloating"
        aria-controls={"#{@id}-panel"}
        aria-haspopup="listbox"
        aria-expanded="false"
        aria-invalid={to_string(@invalid)}
        data-mui-trigger="click"
        data-mui-placement="bottom-start"
        data-mui-axis="vertical"
        data-mui-role="listbox"
        data-mui-value-target={"#{@id}-value"}
        class={
          CN.cn([
            "flex h-9 w-full items-center justify-between gap-2 rounded-mui-sm border border-mui-border-strong bg-mui-surface px-3 text-sm text-mui-foreground shadow-mui-xs",
            "focus-visible:border-mui-primary focus-visible:ring-2 focus-visible:ring-mui-ring/20",
            @invalid && "border-mui-danger focus-visible:ring-mui-danger/30",
            @class
          ])
        }
      >
        <span :if={@selected} data-mui-select-label>{render_slot(@selected)}</span>
        <span :if={!@selected} data-mui-select-label>{@placeholder}</span>
        <svg class="size-4 text-mui-subtle-foreground" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
          <path d="M5.5 7.5L10 12l4.5-4.5" stroke="currentColor" stroke-width="1.5" fill="none" stroke-linecap="round" stroke-linejoin="round" />
        </svg>
      </button>
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
          aria-selected={to_string(to_string(@value) == to_string(option.value))}
          class="flex cursor-pointer items-center justify-between rounded-mui-sm px-2.5 py-1.5 hover:bg-mui-surface-hover aria-selected:bg-mui-primary-subtle aria-selected:text-mui-primary-subtle-foreground"
        >
          {render_slot(option)}
        </div>
      </div>
    </div>
    """
  end
end
