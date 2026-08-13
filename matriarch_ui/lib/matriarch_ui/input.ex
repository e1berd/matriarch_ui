defmodule MatriarchUI.Input do
  @moduledoc "Text input, usable standalone or bound to a `Phoenix.HTML.FormField`."
  use Phoenix.Component
  alias MatriarchUI.CN

  attr :field, Phoenix.HTML.FormField
  attr :type, :string, default: "text"
  attr :label, :string, default: nil
  attr :name, :any, default: nil
  attr :id, :any, default: nil
  attr :value, :any, default: nil
  attr :errors, :list, default: []
  attr :class, :string, default: nil

  attr :rest, :global,
    include: ~w(placeholder autocomplete disabled readonly required min max step)

  slot :leading

  def input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if used_input?(field), do: field.errors, else: []

    assigns
    |> assign(field: nil, errors: Enum.map(errors, &translate/1))
    |> assign_new(:name, fn -> field.name end)
    |> assign_new(:id, fn -> field.id end)
    |> assign_new(:value, fn -> field.value end)
    |> input()
  end

  def input(assigns) do
    ~H"""
    <div data-mui class="flex flex-col gap-1.5">
      <label :if={@label} for={@id} class="text-sm font-medium text-mui-foreground">
        {@label}
      </label>
      <div class="relative flex items-center">
        <span
          :if={@leading != []}
          class="pointer-events-none absolute left-3 flex size-4 items-center text-mui-subtle-foreground"
        >
          {render_slot(@leading)}
        </span>
        <input
          type={@type}
          name={@name}
          id={@id}
          value={Phoenix.HTML.Form.normalize_value(@type, @value)}
          class={
            CN.cn([
              "h-10 w-full rounded-mui-md border border-mui-border-strong bg-mui-surface px-3 text-sm text-mui-foreground",
              "placeholder:text-mui-subtle-foreground focus-visible:border-mui-primary focus-visible:ring-2 focus-visible:ring-mui-ring/30",
              "disabled:cursor-not-allowed disabled:opacity-50",
              @leading != [] && "pl-9",
              @errors != [] && "border-mui-danger focus-visible:ring-mui-danger/30",
              @class
            ])
          }
          {@rest}
        />
      </div>
      <p :for={error <- @errors} class="text-sm text-mui-danger">{error}</p>
    </div>
    """
  end

  defp translate({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end

  defp translate(msg), do: msg
end
