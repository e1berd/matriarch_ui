defmodule MatriarchUI.PasswordInput do
  @moduledoc "Password input with an accessible visibility toggle and form field binding."
  use Phoenix.Component
  alias MatriarchUI.CN
  import MatriarchUI.Icon

  attr :field, Phoenix.HTML.FormField
  attr :name, :any, default: nil
  attr :id, :string, default: nil
  attr :value, :any, default: nil
  attr :invalid, :boolean, default: false
  attr :show_label, :string, default: "Show password"
  attr :hide_label, :string, default: "Hide password"
  attr :class, :string, default: nil

  attr :rest, :global,
    include: ~w(placeholder autocomplete disabled readonly required minlength maxlength)

  def password_input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(
      field: nil,
      invalid: used_input?(field) && field.errors != [],
      name: assigns.name || field.name,
      id: assigns.id || field.id,
      value: if(is_nil(assigns.value), do: field.value, else: assigns.value)
    )
    |> password_input()
  end

  def password_input(assigns) do
    assigns = assign(assigns, :rest, Map.put_new(assigns.rest, :autocomplete, "current-password"))

    ~H"""
    <div id={"#{@id}-password"} data-mui class="relative flex items-center">
      <input
        phx-hook=".MUIPasswordInput"
        data-mui-control
        type="password"
        name={@name}
        id={@id}
        value={Phoenix.HTML.Form.normalize_value("password", @value)}
        aria-invalid={to_string(@invalid)}
        data-mui-password
        class={
          CN.cn([
            "mui-input h-8 w-full rounded-mui-md border border-transparent bg-mui-input-background px-3 pr-9 text-sm text-mui-foreground",
            "placeholder:text-mui-input-placeholder focus-visible:border-mui-brand focus-visible:ring-2 focus-visible:ring-mui-slider-ring",
            "disabled:cursor-not-allowed disabled:opacity-50",
            @invalid && "border-mui-danger focus-visible:ring-mui-danger/30",
            @class
          ])
        }
        {@rest}
      />
      <button
        type="button"
        data-mui-password-toggle
        data-show-label={@show_label}
        data-hide-label={@hide_label}
        aria-label={@show_label}
        aria-pressed="false"
        class="absolute right-1.5 flex size-6 items-center justify-center rounded-mui-sm text-mui-muted-foreground hover:bg-mui-surface-hover hover:text-mui-foreground"
      >
        <.icon name="eye" data-mui-password-show />
        <.icon name="eye-slash" data-mui-password-hide class="hidden" />
      </button>
    </div>
    """
  end

  attr :rest, :global

  def hook(assigns) do
    ~H"""
    <script :type={Phoenix.LiveView.ColocatedHook} name=".MUIPasswordInput">
      export default {
        mounted() {
          const input = this.el
          const root = input.closest("[data-mui]")
          const toggle = root.querySelector("[data-mui-password-toggle]")
          const showIcon = root.querySelector("[data-mui-password-show]")
          const hideIcon = root.querySelector("[data-mui-password-hide]")

          toggle.addEventListener("click", () => {
            const visible = input.type === "password"
            input.type = visible ? "text" : "password"
            toggle.setAttribute("aria-pressed", String(visible))
            toggle.setAttribute("aria-label", visible ? toggle.dataset.hideLabel : toggle.dataset.showLabel)
            showIcon.classList.toggle("hidden", visible)
            hideIcon.classList.toggle("hidden", !visible)
            input.focus({ preventScroll: true })
          })
        }
      }
    </script>
    """
  end
end
