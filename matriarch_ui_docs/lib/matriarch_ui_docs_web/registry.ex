defmodule MatriarchUIDocsWeb.Registry do
  @moduledoc "Single source of truth for the components sidebar and `/docs/components/:slug`."
  alias MatriarchUIDocsWeb.Examples

  @components [
    %{slug: "accordion", title: "Accordion", module: Examples.Accordion},
    %{slug: "alert", title: "Alert", module: Examples.Alert},
    %{slug: "autocomplete", title: "Autocomplete", module: Examples.Autocomplete},
    %{slug: "avatar", title: "Avatar", module: Examples.Avatar},
    %{slug: "badge", title: "Badge", module: Examples.Badge},
    %{slug: "breadcrumb", title: "Breadcrumb", module: Examples.Breadcrumb},
    %{slug: "button", title: "Button", module: Examples.Button},
    %{slug: "card", title: "Card", module: Examples.Card},
    %{slug: "carousel", title: "Carousel", module: Examples.Carousel},
    %{slug: "checkbox", title: "Checkbox", module: Examples.Checkbox},
    %{slug: "dropdown-menu", title: "Dropdown Menu", module: Examples.DropdownMenu},
    %{slug: "field", title: "Field", module: Examples.Field},
    %{slug: "fieldset", title: "Fieldset", module: Examples.Field},
    %{slug: "group", title: "Group", module: Examples.Group},
    %{slug: "input", title: "Input", module: Examples.Input},
    %{slug: "listbox", title: "Listbox", module: Examples.Listbox},
    %{slug: "modal", title: "Modal", module: Examples.Modal},
    %{slug: "pagination", title: "Pagination", module: Examples.Pagination},
    %{slug: "popover", title: "Popover", module: Examples.Popover},
    %{slug: "radio-group", title: "Radio Group", module: Examples.RadioGroup},
    %{slug: "scroll-area", title: "Scroll Area", module: Examples.ScrollArea},
    %{slug: "select", title: "Select", module: Examples.Select},
    %{slug: "separator", title: "Separator", module: Examples.Separator},
    %{slug: "sidebar", title: "Sidebar", module: Examples.Sidebar},
    %{slug: "slider", title: "Slider", module: Examples.Slider},
    %{slug: "splitter", title: "Splitter", module: Examples.Splitter},
    %{slug: "switch", title: "Switch", module: Examples.Switch},
    %{slug: "table", title: "Table", module: Examples.Table},
    %{slug: "tabs", title: "Tabs", module: Examples.Tabs},
    %{slug: "textarea", title: "Textarea", module: Examples.Textarea},
    %{slug: "tooltip", title: "Tooltip", module: Examples.Tooltip}
  ]

  def components, do: @components

  def fetch(slug), do: Enum.find(@components, &(&1.slug == slug))
end
