defmodule MatriarchUIDocsWeb.Registry do
  @moduledoc "Single source of truth for the components sidebar and `/docs/components/:slug`."
  alias MatriarchUIDocsWeb.Examples

  @components [
    %{slug: "alert", title: "Alert", module: Examples.Alert},
    %{slug: "avatar", title: "Avatar", module: Examples.Avatar},
    %{slug: "badge", title: "Badge", module: Examples.Badge},
    %{slug: "button", title: "Button", module: Examples.Button},
    %{slug: "card", title: "Card", module: Examples.Card},
    %{slug: "checkbox", title: "Checkbox", module: Examples.Checkbox},
    %{slug: "dropdown-menu", title: "Dropdown Menu", module: Examples.DropdownMenu},
    %{slug: "input", title: "Input", module: Examples.Input},
    %{slug: "modal", title: "Modal", module: Examples.Modal},
    %{slug: "popover", title: "Popover", module: Examples.Popover},
    %{slug: "radio-group", title: "Radio Group", module: Examples.RadioGroup},
    %{slug: "select", title: "Select", module: Examples.Select},
    %{slug: "separator", title: "Separator", module: Examples.Separator},
    %{slug: "switch", title: "Switch", module: Examples.Switch},
    %{slug: "tabs", title: "Tabs", module: Examples.Tabs},
    %{slug: "textarea", title: "Textarea", module: Examples.Textarea},
    %{slug: "tooltip", title: "Tooltip", module: Examples.Tooltip}
  ]

  def components, do: @components

  def fetch(slug), do: Enum.find(@components, &(&1.slug == slug))
end
