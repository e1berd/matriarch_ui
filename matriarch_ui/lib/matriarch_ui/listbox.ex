defmodule MatriarchUI.Listbox do
  @moduledoc """
  Always-visible selectable list (not a floating popover — see `MatriarchUI.Select`
  for that). Each option is a native radio/checkbox wrapped in its own label,
  so focus/selection/keyboard nav all come from the browser for free.
  """
  use Phoenix.Component
  alias MatriarchUI.CN

  attr :id, :string, required: true
  attr :field, Phoenix.HTML.FormField
  attr :name, :any, default: nil
  attr :value, :any, default: nil
  attr :multiple, :boolean, default: false
  attr :class, :string, default: nil

  slot :option, required: true do
    attr :value, :string, required: true
  end

  def listbox(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil)
    |> assign_new(:name, fn -> field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> listbox()
  end

  def listbox(assigns) do
    ~H"""
    <div
      id={@id}
      data-mui
      role="listbox"
      aria-multiselectable={to_string(@multiple)}
      class={
        CN.cn([
          "flex flex-col gap-0.5 rounded-mui-lg border border-mui-border bg-mui-surface p-1",
          @class
        ])
      }
    >
      <label
        :for={option <- @option}
        role="option"
        aria-selected={to_string(selected?(option.value, @value))}
        class="flex cursor-pointer items-center gap-2 rounded-mui-md px-2 py-1 text-sm text-mui-foreground hover:bg-mui-surface-hover has-checked:bg-mui-primary-subtle has-checked:text-mui-primary-subtle-foreground"
      >
        <input
          type={if @multiple, do: "checkbox", else: "radio"}
          name={@name}
          value={option.value}
          checked={selected?(option.value, @value)}
          class="sr-only"
        />
        {render_slot(option)}
      </label>
    </div>
    """
  end

  defp selected?(value, selected) when is_list(selected) do
    to_string(value) in Enum.map(selected, &to_string/1)
  end

  defp selected?(value, selected), do: to_string(value) == to_string(selected)
end
