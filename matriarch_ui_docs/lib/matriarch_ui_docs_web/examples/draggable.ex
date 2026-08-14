defmodule MatriarchUIDocsWeb.Examples.Draggable do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      locale={@locale}
      title="Realtime sortable list"
      description="Drag by the handle, or press Space and use ArrowUp/ArrowDown. A placeholder previews the destination, surrounding items animate, and the order stays synchronized in another tab."
      class="flex-col items-stretch"
      code={
        ~S'''
        <span data-mui-draggable-status-for="project-sections">connecting</span>
        <.draggable
          id="project-sections"
          name="project[section_order]"
          event=""
          document="matriarch-ui-docs-project-sections"
          class="gap-2"
        >
          <:preview class="border-mui-accent bg-mui-accent-subtle" />
          <:item id="research">
            <div class="flex items-center gap-3 rounded-mui-lg border border-mui-border bg-mui-surface p-3">
              <.draggable_handle label="Move Research" />
              <span class="font-medium text-mui-foreground">Research</span>
            </div>
          </:item>
          <:item id="design">
            <div class="flex items-center gap-3 rounded-mui-lg border border-mui-border bg-mui-surface p-3">
              <.draggable_handle label="Move Design" />
              <span class="font-medium text-mui-foreground">Design</span>
            </div>
          </:item>
          <:item id="delivery">
            <div class="flex items-center gap-3 rounded-mui-lg border border-mui-border bg-mui-surface p-3">
              <.draggable_handle label="Move Delivery" />
              <span class="font-medium text-mui-foreground">Delivery</span>
            </div>
          </:item>
        </.draggable>
        '''
      }
    >
      <span data-mui-draggable-status-for="project-sections">connecting</span>
      <.draggable
        id="project-sections"
        name="project[section_order]"
        event=""
        document="matriarch-ui-docs-project-sections"
        class="gap-2"
      >
        <:preview class="border-mui-accent bg-mui-accent-subtle" />
        <:item id="research">
          <div class="flex items-center gap-3 rounded-mui-lg border border-mui-border bg-mui-surface p-3">
            <.draggable_handle label="Move Research" />
            <span class="font-medium text-mui-foreground">Research</span>
          </div>
        </:item>
        <:item id="design">
          <div class="flex items-center gap-3 rounded-mui-lg border border-mui-border bg-mui-surface p-3">
            <.draggable_handle label="Move Design" />
            <span class="font-medium text-mui-foreground">Design</span>
          </div>
        </:item>
        <:item id="delivery">
          <div class="flex items-center gap-3 rounded-mui-lg border border-mui-border bg-mui-surface p-3">
            <.draggable_handle label="Move Delivery" />
            <span class="font-medium text-mui-foreground">Delivery</span>
          </div>
        </:item>
      </.draggable>
    </.example>

    <.props_table
      locale={@locale}
      rows={[
        {"id", "string", "unique id for the sortable root and hook"},
        {"orientation", "vertical | horizontal", "axis used by drag and keyboard movement"},
        {"event", "string",
         "LiveView event receiving id, indices, and order; empty disables pushEvent"},
        {"target", "string", "optional pushEventTo selector"},
        {"name", "string", "optional hidden input containing the JSON order"},
        {"collaboration_socket", "string", "Phoenix Socket path used for realtime order"},
        {"document", "string", "shared realtime document name; nil disables collaboration"},
        {"animation_duration", "integer", "movement animation duration in milliseconds"},
        {"disabled", "boolean", "disables reordering for the entire list"},
        {"class", "string", "merged with the sortable root classes"},
        {"item_class", "string", "merged into every item wrapper"},
        {":preview", "slot", "optional content and classes for the destination preview"},
        {":item", "slot", "sortable content; requires a stable id and accepts disabled/class"}
      ]}
    />
    """
  end
end
