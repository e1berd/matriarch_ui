defmodule MatriarchUI.Table do
  @moduledoc "Composable data table with a LiveView-compatible filter form."
  use Phoenix.Component
  alias MatriarchUI.CN

  attr :id, :string, required: true
  attr :class, :string, default: nil
  attr :container_class, :string, default: nil
  slot :inner_block, required: true

  def table(assigns) do
    ~H"""
    <div
      data-mui
      data-slot="table"
      class={
        CN.cn([
          "relative w-full overflow-auto rounded-mui-xl border border-mui-card-border bg-mui-card",
          @container_class
        ])
      }
    >
      <table
        id={@id}
        class={CN.cn(["w-full border-collapse caption-bottom text-sm", @class])}
      >
        {render_slot(@inner_block)}
      </table>
    </div>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def table_header(assigns) do
    ~H"""
    <thead data-slot="table-header" class={CN.cn([@class])}>{render_slot(@inner_block)}</thead>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def table_body(assigns) do
    ~H"""
    <tbody
      data-slot="table-body"
      class={
        CN.cn([
          "[&_tr]:border-b [&_tr]:border-mui-card-border [&_tr:last-child]:border-b-0",
          "[&_td]:bg-mui-card [&_tr:hover_td]:bg-mui-surface-hover/50",
          @class
        ])
      }
    >
      {render_slot(@inner_block)}
    </tbody>
    """
  end

  attr :selected, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def table_row(assigns) do
    ~H"""
    <tr
      data-slot="table-row"
      data-state={@selected && "selected"}
      class={CN.cn(["border-b border-mui-card-border data-[state=selected]:bg-mui-primary-subtle", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </tr>
    """
  end

  attr :scope, :string, default: "col"
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(colspan rowspan)
  slot :inner_block, required: true

  def table_head(assigns) do
    ~H"""
    <th
      data-slot="table-head"
      scope={@scope}
      class={CN.cn(["h-10 border-b border-mui-card-border px-4 text-left text-sm font-medium text-mui-muted-foreground", @class])}
      {@rest}
    >
      <div class="flex w-full items-center gap-2">{render_slot(@inner_block)}</div>
    </th>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(colspan rowspan)
  slot :inner_block, required: true

  def table_cell(assigns) do
    ~H"""
    <td data-slot="table-cell" class={CN.cn(["px-4 py-2 align-middle", @class])} {@rest}>
      {render_slot(@inner_block)}
    </td>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def table_footer(assigns) do
    ~H"""
    <tfoot data-slot="table-footer" class={CN.cn(["font-medium [&_tr]:h-10", @class])}>
      {render_slot(@inner_block)}
    </tfoot>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def table_caption(assigns) do
    ~H"""
    <caption data-slot="table-caption" class={CN.cn(["mt-4 text-sm text-mui-muted-foreground", @class])}>
      {render_slot(@inner_block)}
    </caption>
    """
  end

  attr :colspan, :integer, default: 1
  attr :class, :string, default: nil
  slot :inner_block, required: true

  def table_empty(assigns) do
    ~H"""
    <.table_row>
      <.table_cell colspan={@colspan} class={CN.cn(["p-4", @class])}>
        <div class="flex items-center justify-center py-10 text-sm text-mui-muted-foreground">
          {render_slot(@inner_block)}
        </div>
      </.table_cell>
    </.table_row>
    """
  end

  attr :id, :string, required: true
  attr :for, :any, required: true
  attr :event, :string, default: "filter"
  attr :target, :any, default: nil
  attr :class, :string, default: nil
  slot :inner_block, required: true

  def table_filters(assigns) do
    ~H"""
    <.form
      for={@for}
      id={@id}
      phx-change={@event}
      phx-submit={@event}
      phx-target={@target}
      class={CN.cn(["flex flex-wrap items-end gap-2", @class])}
    >
      {render_slot(@inner_block)}
    </.form>
    """
  end
end
