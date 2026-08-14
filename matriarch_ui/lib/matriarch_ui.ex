defmodule MatriarchUI do
  @moduledoc """
  `use MatriarchUI` inside your app's `html_helpers` block to import every
  component (`<.button>`, `<.input>`, `<.select>`, ...) in one line.
  """

  defmacro __using__(_opts) do
    quote do
      import MatriarchUI.Accordion
      import MatriarchUI.Alert
      import MatriarchUI.Autocomplete
      import MatriarchUI.Avatar
      import MatriarchUI.Badge
      import MatriarchUI.Breadcrumb
      import MatriarchUI.Button
      import MatriarchUI.Card
      import MatriarchUI.Carousel
      import MatriarchUI.Checkbox
      import MatriarchUI.DropdownMenu
      import MatriarchUI.Field
      import MatriarchUI.Fieldset
      import MatriarchUI.Input
      import MatriarchUI.Listbox
      import MatriarchUI.Modal
      import MatriarchUI.Pagination
      import MatriarchUI.Popover
      import MatriarchUI.RadioGroup
      import MatriarchUI.ScrollArea
      import MatriarchUI.Select
      import MatriarchUI.Separator
      import MatriarchUI.Sidebar
      import MatriarchUI.Slider
      import MatriarchUI.Splitter
      import MatriarchUI.Switch
      import MatriarchUI.Tabs
      import MatriarchUI.Textarea
      import MatriarchUI.Tooltip
    end
  end
end
