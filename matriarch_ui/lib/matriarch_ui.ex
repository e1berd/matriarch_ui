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
      import MatriarchUI.Chat
      import MatriarchUI.ChatMessages
      import MatriarchUI.Checkbox
      import MatriarchUI.ColorInput
      import MatriarchUI.CommandPalette
      import MatriarchUI.DateInput
      import MatriarchUI.DatePicker
      import MatriarchUI.DropdownMenu
      import MatriarchUI.Draggable
      import MatriarchUI.EmailInput
      import MatriarchUI.Field
      import MatriarchUI.Fieldset
      import MatriarchUI.FileUpload
      import MatriarchUI.Group
      import MatriarchUI.Input
      import MatriarchUI.Icon
      import MatriarchUI.Kbd
      import MatriarchUI.List
      import MatriarchUI.Listbox
      import MatriarchUI.Modal
      import MatriarchUI.NotionEditor
      import MatriarchUI.NumberInput
      import MatriarchUI.Pagination
      import MatriarchUI.PasswordInput
      import MatriarchUI.PhoneInput
      import MatriarchUI.Popover
      import MatriarchUI.Progress
      import MatriarchUI.Radio
      import MatriarchUI.RadioGroup
      import MatriarchUI.RichEditor
      import MatriarchUI.RichEditor.DragHandle
      import MatriarchUI.RichEditor.Toolbar
      import MatriarchUI.ScrollArea
      import MatriarchUI.Select
      import MatriarchUI.Separator
      import MatriarchUI.Sidebar
      import MatriarchUI.Slider
      import MatriarchUI.Splitter
      import MatriarchUI.Spinner
      import MatriarchUI.Switch
      import MatriarchUI.Table
      import MatriarchUI.Tabs
      import MatriarchUI.Textarea
      import MatriarchUI.ThemeToggle
      import MatriarchUI.Tooltip
    end
  end
end
