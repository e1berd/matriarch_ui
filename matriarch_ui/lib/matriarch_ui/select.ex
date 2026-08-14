defmodule MatriarchUI.Select do
  @moduledoc "Bare listbox-style select — pair with `MatriarchUI.Field` for a label and validation errors."
  use Phoenix.Component
  alias MatriarchUI.{CN, Floating}
  import MatriarchUI.Icon

  attr :id, :string, required: true
  attr :field, Phoenix.HTML.FormField
  attr :name, :any, default: nil
  attr :value, :any, default: nil
  attr :multiple, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :placeholder, :string, default: "Select…"
  attr :invalid, :boolean, default: false
  attr :match_width, :boolean, default: true
  attr :class, :string, default: nil
  attr :panel_class, :string, default: nil

  slot :option, required: true do
    attr :value, :string, required: true
    attr :label, :string, doc: "plain-text mirror shown in the trigger after a client-side pick"
  end

  def select(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(
      field: nil,
      invalid: used_input?(field) && field.errors != [],
      name: assigns.name || field.name,
      value: if(is_nil(assigns.value), do: field.value, else: assigns.value)
    )
    |> select()
  end

  def select(assigns) do
    selected_values = selected_values(assigns.value, assigns.multiple)

    assigns =
      assigns
      |> assign(:selected_values, selected_values)
      |> assign(:selected, Enum.filter(assigns.option, &(to_string(&1.value) in selected_values)))
      |> assign(:multiple_name, multiple_name(assigns.name))

    ~H"""
    <div data-mui>
      <input :if={!@multiple} type="hidden" id={"#{@id}-value"} name={@name} value={@value} disabled={@disabled} />
      <select :if={@multiple} id={"#{@id}-value"} name={@multiple_name} multiple hidden disabled={@disabled}>
        <option
          :for={option <- @option}
          value={option.value}
          selected={to_string(option.value) in @selected_values}
        >
          {option[:label] || option.value}
        </option>
      </select>
      <button
        data-mui-control
        type="button"
        disabled={@disabled}
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
        data-mui-match-width={to_string(@match_width)}
        data-mui-value-target={"#{@id}-value"}
        data-mui-multiple={to_string(@multiple)}
        data-mui-placeholder={@placeholder}
        class={
          CN.cn([
            "flex h-8 w-full items-center justify-between gap-2 rounded-mui-md border border-mui-border bg-mui-surface px-3 text-sm text-mui-foreground",
            "focus-visible:border-mui-primary focus-visible:ring-2 focus-visible:ring-mui-ring/20 disabled:cursor-not-allowed disabled:opacity-50",
            @invalid && "border-mui-danger focus-visible:ring-mui-danger/30",
            @class
          ])
        }
      >
        <span :if={@selected != []} data-mui-select-label class="truncate">
          <%= for {option, index} <- Enum.with_index(@selected) do %>
            <span :if={index > 0}>, </span><%= if option[:label], do: option.label, else: render_slot(option) %>
          <% end %>
        </span>
        <span :if={@selected == []} data-mui-select-label class="truncate">{@placeholder}</span>
        <.icon name="caret-down" class="text-mui-subtle-foreground" />
      </button>
      <div
        id={"#{@id}-panel"}
        role="listbox"
        aria-multiselectable={@multiple && "true"}
        data-mui-state="closed"
        class={
          CN.cn([
            Floating.panel_class(),
            "max-h-64 overflow-auto rounded-mui-md border border-mui-border bg-mui-surface p-1 text-[13px] shadow-mui-lg",
            @panel_class
          ])
        }
      >
        <div
          :for={option <- @option}
          role="option"
          tabindex="-1"
          data-mui-value={option.value}
          data-mui-label={option[:label]}
          aria-selected={to_string(to_string(option.value) in @selected_values)}
          class="group/option flex min-h-7 cursor-pointer items-center justify-between gap-2 rounded-mui-sm px-2 py-1 hover:bg-mui-surface-hover focus-visible:bg-mui-surface-hover focus-visible:outline-none aria-selected:bg-mui-primary-subtle aria-selected:text-mui-primary-subtle-foreground"
        >
          <span class="truncate">{render_slot(option)}</span>
          <.icon
            name="check"
            class="invisible size-3.5 text-mui-brand group-aria-[selected=true]/option:visible"
          />
        </div>
      </div>
    </div>
    """
  end

  defp selected_values(value, true), do: value |> List.wrap() |> Enum.map(&to_string/1)
  defp selected_values(nil, false), do: []
  defp selected_values(value, false), do: [to_string(value)]

  defp multiple_name(nil), do: nil

  defp multiple_name(name) do
    name = to_string(name)
    if String.ends_with?(name, "[]"), do: name, else: "#{name}[]"
  end
end
