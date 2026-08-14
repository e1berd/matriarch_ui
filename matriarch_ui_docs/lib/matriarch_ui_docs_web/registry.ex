defmodule MatriarchUIDocsWeb.Registry do
  @moduledoc "Single source of truth for the components sidebar and `/docs/components/:slug`."
  alias MatriarchUIDocsWeb.Examples
  alias MatriarchUIDocsWeb.DocsI18n

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
    %{slug: "chat", title: "Chat", module: Examples.Chat},
    %{slug: "checkbox", title: "Checkbox", module: Examples.Checkbox},
    %{slug: "color-input", title: "Color Input", module: Examples.ColorInput},
    %{slug: "command-palette", title: "Command Palette", module: Examples.CommandPalette},
    %{slug: "date-input", title: "Date Input", module: Examples.DateInput},
    %{slug: "date-picker", title: "Date Picker", module: Examples.DatePicker},
    %{slug: "draggable", title: "Draggable", module: Examples.Draggable},
    %{slug: "dropdown-menu", title: "Dropdown Menu", module: Examples.DropdownMenu},
    %{slug: "email-input", title: "Email Input", module: Examples.EmailInput},
    %{slug: "field", title: "Field", module: Examples.Field},
    %{slug: "fieldset", title: "Fieldset", module: Examples.Fieldset},
    %{slug: "file-upload", title: "File Upload", module: Examples.FileUpload},
    %{slug: "group", title: "Group", module: Examples.Group},
    %{slug: "input", title: "Input", module: Examples.Input},
    %{slug: "kbd", title: "Kbd", module: Examples.Kbd},
    %{slug: "list", title: "List", module: Examples.List},
    %{slug: "listbox", title: "Listbox", module: Examples.Listbox},
    %{slug: "modal", title: "Modal", module: Examples.Modal},
    %{slug: "number-input", title: "Number Input", module: Examples.NumberInput},
    %{slug: "pagination", title: "Pagination", module: Examples.Pagination},
    %{slug: "password-input", title: "Password Input", module: Examples.PasswordInput},
    %{slug: "phone-input", title: "Phone Input", module: Examples.PhoneInput},
    %{slug: "popover", title: "Popover", module: Examples.Popover},
    %{slug: "progressbar", title: "Progress Bar", module: Examples.Progress},
    %{slug: "radio", title: "Radio", module: Examples.Radio},
    %{slug: "radio-group", title: "Radio Group", module: Examples.RadioGroup},
    %{slug: "rich-editor", title: "Rich Editor", module: Examples.RichEditor},
    %{slug: "scroll-area", title: "Scroll Area", module: Examples.ScrollArea},
    %{slug: "select", title: "Select", module: Examples.Select},
    %{slug: "separator", title: "Separator", module: Examples.Separator},
    %{slug: "sidebar", title: "Sidebar", module: Examples.Sidebar},
    %{slug: "slider", title: "Slider", module: Examples.Slider},
    %{slug: "splitter", title: "Splitter", module: Examples.Splitter},
    %{slug: "spinner", title: "Spinner", module: Examples.Spinner},
    %{slug: "switch", title: "Switch", module: Examples.Switch},
    %{slug: "table", title: "Table", module: Examples.Table},
    %{slug: "tabs", title: "Tabs", module: Examples.Tabs},
    %{slug: "textarea", title: "Textarea", module: Examples.Textarea},
    %{slug: "tooltip", title: "Tooltip", module: Examples.Tooltip}
  ]

  def components, do: @components

  def components(locale) do
    Enum.map(@components, fn component ->
      Map.put(component, :title, DocsI18n.component_title(locale, component))
    end)
  end

  def fetch(slug), do: Enum.find(@components, &(&1.slug == slug))

  def fetch(slug, locale), do: Enum.find(components(locale), &(&1.slug == slug))
end
