defmodule MatriarchUI.DropdownMenu do
  @moduledoc "Click-triggered action menu with arrow-key navigation, anchored via `.MUIFloating`."
  use Phoenix.Component
  alias MatriarchUI.{CN, Floating}

  attr :id, :string, required: true
  attr :placement, :string, default: "bottom-start"
  attr :class, :string, default: nil
  slot :trigger, required: true

  slot :item, required: true do
    attr :navigate, :string
    attr :patch, :string
    attr :href, :string
    attr :variant, :string
  end

  def dropdown_menu(assigns) do
    ~H"""
    <button
      type="button"
      id={"#{@id}-trigger"}
      phx-hook="MatriarchUI.Floating.MUIFloating"
      aria-controls={"#{@id}-panel"}
      aria-haspopup="menu"
      aria-expanded="false"
      data-mui-trigger="click"
      data-mui-placement={@placement}
      data-mui-role="menu"
      class="inline-flex"
    >
      {render_slot(@trigger)}
    </button>
    <div
      id={"#{@id}-panel"}
      role="menu"
      data-mui-state="closed"
      class={
        CN.cn([
          Floating.panel_class(),
          "min-w-48 rounded-mui-lg border border-mui-border bg-mui-surface p-1 text-sm shadow-mui-lg",
          @class
        ])
      }
    >
      <.link
        :for={item <- @item}
        navigate={item[:navigate]}
        patch={item[:patch]}
        href={item_href(item)}
        role="menuitem"
        tabindex="-1"
        data-mui-close
        class={[
          "flex w-full items-center gap-2 rounded-mui-sm px-2.5 py-1.5 text-left outline-none",
          "hover:bg-mui-surface-hover focus:bg-mui-surface-hover",
          item[:variant] == "danger" && "text-mui-danger"
        ]}
        {item_rest(item)}
      >
        {render_slot(item)}
      </.link>
    </div>
    """
  end

  defp item_href(%{navigate: nav}) when is_binary(nav), do: nil
  defp item_href(%{patch: patch}) when is_binary(patch), do: nil
  defp item_href(%{href: href}) when is_binary(href), do: href
  defp item_href(_), do: "#"

  defp item_rest(item) do
    Map.drop(item, [:__slot__, :inner_block, :navigate, :patch, :href, :variant])
  end
end
