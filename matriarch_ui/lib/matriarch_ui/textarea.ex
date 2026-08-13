defmodule MatriarchUI.Textarea do
  @moduledoc "Multi-line text input, usable standalone or bound to a `Phoenix.HTML.FormField`."
  use Phoenix.Component
  alias MatriarchUI.CN

  attr :field, Phoenix.HTML.FormField
  attr :label, :string, default: nil
  attr :name, :any, default: nil
  attr :id, :any, default: nil
  attr :value, :any, default: nil
  attr :errors, :list, default: []
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(placeholder disabled readonly required rows)

  def textarea(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if used_input?(field), do: field.errors, else: []

    assigns
    |> assign(field: nil, errors: Enum.map(errors, &translate/1))
    |> assign_new(:name, fn -> field.name end)
    |> assign_new(:id, fn -> field.id end)
    |> assign_new(:value, fn -> field.value end)
    |> textarea()
  end

  def textarea(assigns) do
    ~H"""
    <div data-mui class="flex flex-col gap-1.5">
      <label :if={@label} for={@id} class="text-sm font-medium text-mui-foreground">
        {@label}
      </label>
      <textarea
        name={@name}
        id={@id}
        class={
          CN.cn([
            "min-h-24 w-full rounded-mui-md border border-mui-border-strong bg-mui-surface px-3 py-2 text-sm text-mui-foreground",
            "placeholder:text-mui-subtle-foreground focus-visible:border-mui-primary focus-visible:ring-2 focus-visible:ring-mui-ring/30",
            "disabled:cursor-not-allowed disabled:opacity-50",
            @errors != [] && "border-mui-danger focus-visible:ring-mui-danger/30",
            @class
          ])
        }
        {@rest}
      >{Phoenix.HTML.Form.normalize_value("textarea", @value)}</textarea>
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
