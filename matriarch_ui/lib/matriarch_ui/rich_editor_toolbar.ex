defmodule MatriarchUI.RichEditor.Toolbar do
  @moduledoc "Toolbar controls for every command enabled by `MatriarchUI.RichEditor`."
  use Phoenix.Component
  alias MatriarchUI.CN
  import MatriarchUI.Button
  import MatriarchUI.Icon

  @commands ~w(
    add-column-after add-column-before add-row-after add-row-before align-center align-justify
    align-left align-right background-color blockquote bold bullet-list clear-formatting code
    code-block delete-column delete-row delete-table font-family font-size hard-break heading
    highlight horizontal-rule image insert-table italic lift-list-item line-height link merge-cells
    ordered-list paragraph redo sink-list-item split-cell strike subscript superscript task-list
    text-color toggle-header-cell toggle-header-column toggle-header-row underline unlink undo
  )
  @toggle_commands ~w(
    align-center align-justify align-left align-right blockquote bold bullet-list code code-block
    heading highlight italic link ordered-list paragraph strike subscript superscript task-list underline
  )

  attr :command, :string, required: true, values: @commands
  attr :label, :string, required: true
  attr :icon, :string, required: true
  attr :value, :string, default: nil
  attr :prompt, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block

  def toolbar_button(assigns) do
    assigns = assign(assigns, :toggle?, assigns.command in @toggle_commands)

    ~H"""
    <.button
      type="button"
      variant="ghost"
      size="icon"
      data-mui-rich-command={@command}
      data-mui-rich-value={@value}
      data-mui-rich-prompt={@prompt}
      aria-label={@label}
      aria-pressed={@toggle? && "false"}
      title={@label}
      class={
        CN.cn([
          "text-mui-muted-foreground aria-pressed:bg-mui-primary-subtle aria-pressed:text-mui-primary-subtle-foreground",
          @class
        ])
      }
      {@rest}
    >
      <.icon name={@icon} />
      {render_slot(@inner_block)}
    </.button>
    """
  end

  @controls [
    {:toolbar_bold, "bold", "Bold", "text-b"},
    {:toolbar_italic, "italic", "Italic", "text-italic"},
    {:toolbar_underline, "underline", "Underline", "text-underline"},
    {:toolbar_strike, "strike", "Strike", "text-strikethrough"},
    {:toolbar_code, "code", "Inline code", "code"},
    {:toolbar_highlight, "highlight", "Highlight", "highlighter"},
    {:toolbar_subscript, "subscript", "Subscript", "text-subscript"},
    {:toolbar_superscript, "superscript", "Superscript", "text-superscript"},
    {:toolbar_paragraph, "paragraph", "Paragraph", "paragraph"},
    {:toolbar_bullet_list, "bullet-list", "Bullet list", "list-bullets"},
    {:toolbar_ordered_list, "ordered-list", "Ordered list", "list-numbers"},
    {:toolbar_task_list, "task-list", "Task list", "list-checks"},
    {:toolbar_sink_list_item, "sink-list-item", "Indent list item", "text-indent"},
    {:toolbar_lift_list_item, "lift-list-item", "Outdent list item", "text-outdent"},
    {:toolbar_blockquote, "blockquote", "Blockquote", "quotes"},
    {:toolbar_code_block, "code-block", "Code block", "code-block"},
    {:toolbar_horizontal_rule, "horizontal-rule", "Horizontal rule", "minus"},
    {:toolbar_hard_break, "hard-break", "Hard break", "arrow-bend-down-left"},
    {:toolbar_align_left, "align-left", "Align left", "text-align-left"},
    {:toolbar_align_center, "align-center", "Align center", "text-align-center"},
    {:toolbar_align_right, "align-right", "Align right", "text-align-right"},
    {:toolbar_align_justify, "align-justify", "Justify", "text-align-justify"},
    {:toolbar_unlink, "unlink", "Remove link", "link-break"},
    {:toolbar_insert_table, "insert-table", "Insert table", "table"},
    {:toolbar_add_column_before, "add-column-before", "Add column before", "columns-plus-left"},
    {:toolbar_add_column_after, "add-column-after", "Add column after", "columns-plus-right"},
    {:toolbar_delete_column, "delete-column", "Delete column", "columns"},
    {:toolbar_add_row_before, "add-row-before", "Add row before", "rows-plus-top"},
    {:toolbar_add_row_after, "add-row-after", "Add row after", "rows-plus-bottom"},
    {:toolbar_delete_row, "delete-row", "Delete row", "rows"},
    {:toolbar_delete_table, "delete-table", "Delete table", "trash"},
    {:toolbar_merge_cells, "merge-cells", "Merge cells", "arrows-out-simple"},
    {:toolbar_split_cell, "split-cell", "Split cell", "selection-plus"},
    {:toolbar_toggle_header_row, "toggle-header-row", "Toggle header row", "rows"},
    {:toolbar_toggle_header_column, "toggle-header-column", "Toggle header column", "columns"},
    {:toolbar_toggle_header_cell, "toggle-header-cell", "Toggle header cell", "selection"},
    {:toolbar_clear_formatting, "clear-formatting", "Clear formatting", "eraser"},
    {:toolbar_undo, "undo", "Undo", "arrow-u-up-left"},
    {:toolbar_redo, "redo", "Redo", "arrow-u-up-right"}
  ]

  @value_controls [
    {:toolbar_text_color, "text-color", "Text color", "palette", "CSS text color"},
    {:toolbar_background_color, "background-color", "Background color", "paint-bucket",
     "CSS background color"},
    {:toolbar_font_family, "font-family", "Font family", "text-aa", "Font family"},
    {:toolbar_font_size, "font-size", "Font size", "text-aa", "Font size, for example 18px"},
    {:toolbar_line_height, "line-height", "Line height", "line-segment", "Line height"}
  ]

  for {name, command, label, icon} <- @controls do
    def unquote(name)(assigns),
      do: control(assigns, unquote(command), unquote(label), unquote(icon))
  end

  for {name, command, label, icon, prompt} <- @value_controls do
    def unquote(name)(assigns) do
      value_control(assigns, unquote(command), unquote(label), unquote(icon), unquote(prompt))
    end
  end

  attr :level, :integer, default: 1, values: 1..6
  attr :label, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global

  def toolbar_heading(assigns) do
    assigns
    |> assign(
      command: "heading",
      icon: "text-h-#{heading_name(assigns.level)}",
      label: assigns.label || "Heading #{assigns.level}",
      value: to_string(assigns.level),
      prompt: nil,
      inner_block: []
    )
    |> toolbar_button()
  end

  attr :label, :string, default: "Link"
  attr :url, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global

  def toolbar_link(assigns) do
    assigns
    |> assign(
      command: "link",
      icon: "link",
      value: assigns.url,
      prompt: "Link URL",
      inner_block: []
    )
    |> toolbar_button()
  end

  attr :label, :string, default: "Image"
  attr :src, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global

  def toolbar_image(assigns) do
    assigns
    |> assign(
      command: "image",
      icon: "image",
      value: assigns.src,
      prompt: "Image URL",
      inner_block: []
    )
    |> toolbar_button()
  end

  defp control(assigns, command, label, icon) do
    assigns
    |> normalized_assigns(label)
    |> assign(command: command, icon: icon, value: nil, prompt: nil, inner_block: [])
    |> toolbar_button()
  end

  defp value_control(assigns, command, label, icon, prompt) do
    value = Map.get(assigns, :value)

    assigns
    |> normalized_assigns(label, [:value])
    |> assign(command: command, icon: icon, value: value, prompt: prompt, inner_block: [])
    |> toolbar_button()
  end

  defp normalized_assigns(assigns, label, extra_keys \\ []) do
    known_keys = [:__changed__, :class, :label, :rest | extra_keys]
    rest = Map.merge(Map.get(assigns, :rest, %{}), Map.drop(assigns, known_keys))

    assign(assigns,
      label: Map.get(assigns, :label, label),
      class: Map.get(assigns, :class),
      rest: rest
    )
  end

  defp heading_name(1), do: "one"
  defp heading_name(2), do: "two"
  defp heading_name(3), do: "three"
  defp heading_name(4), do: "four"
  defp heading_name(5), do: "five"
  defp heading_name(6), do: "six"
end
