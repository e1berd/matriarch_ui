defmodule MatriarchUI.Select do
  @moduledoc "Listbox-style select, usable standalone or bound to a `Phoenix.HTML.FormField`."
  use Phoenix.Component
  alias MatriarchUI.{CN, Floating}

  attr :id, :string, required: true
  attr :field, Phoenix.HTML.FormField
  attr :name, :any, default: nil
  attr :value, :any, default: nil
  attr :label, :string, default: nil
  attr :placeholder, :string, default: "Select…"
  attr :options, :list, required: true, doc: "list of `{label, value}` tuples"
  attr :class, :string, default: nil

  def select(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil)
    |> assign_new(:name, fn -> field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> select()
  end

  def select(assigns) do
    assigns =
      assign(
        assigns,
        :current_label,
        current_label(assigns.options, assigns.value, assigns.placeholder)
      )

    ~H"""
    <div data-mui class="flex flex-col gap-1.5">
      <label :if={@label} for={"#{@id}-trigger"} class="text-sm font-medium text-mui-foreground">
        {@label}
      </label>
      <input type="hidden" id={"#{@id}-value"} name={@name} value={@value} />
      <button
        type="button"
        id={"#{@id}-trigger"}
        phx-hook="MatriarchUI.Floating.MUIFloating"
        aria-controls={"#{@id}-panel"}
        aria-haspopup="listbox"
        aria-expanded="false"
        data-mui-trigger="click"
        data-mui-placement="bottom-start"
        data-mui-role="listbox"
        data-mui-value-target={"#{@id}-value"}
        class={
          CN.cn([
            "flex h-10 w-full items-center justify-between gap-2 rounded-mui-md border border-mui-border-strong bg-mui-surface px-3 text-sm text-mui-foreground",
            "focus-visible:border-mui-primary focus-visible:ring-2 focus-visible:ring-mui-ring/30",
            @class
          ])
        }
      >
        <span data-mui-select-label>{@current_label}</span>
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
          :for={{option_label, option_value} <- @options}
          role="option"
          tabindex="-1"
          data-mui-value={option_value}
          data-mui-label={option_label}
          aria-selected={to_string(to_string(@value) == to_string(option_value))}
          class="flex cursor-pointer items-center justify-between rounded-mui-sm px-2.5 py-1.5 hover:bg-mui-surface-hover aria-selected:bg-mui-primary-subtle aria-selected:text-mui-primary-subtle-foreground"
        >
          {option_label}
        </div>
      </div>
    </div>
    """
  end

  defp current_label(options, value, placeholder) do
    Enum.find_value(options, placeholder, fn {label, option_value} ->
      to_string(option_value) == to_string(value) && label
    end)
  end
end
