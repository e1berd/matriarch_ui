defmodule MatriarchUIDocsWeb.Examples.DropdownMenu do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      title="Basic"
      code={
        ~S'''
        <.dropdown_menu id="row-actions">
          <:trigger><.button variant="outline">Actions</.button></:trigger>
          <:item navigate="/docs">Edit</:item>
          <:item navigate="/docs">Duplicate</:item>
          <:item variant="danger">Delete</:item>
        </.dropdown_menu>
        '''
      }
    >
      <.dropdown_menu id="row-actions">
        <:trigger><.button variant="outline">Actions</.button></:trigger>
        <:item navigate="/docs">Edit</:item>
        <:item navigate="/docs">Duplicate</:item>
        <:item variant="danger">Delete</:item>
      </.dropdown_menu>
    </.example>

    <.props_table rows={[
      {"id", "string, required", "unique id for the trigger/panel pair"},
      {"trigger", "slot, required", "the clickable trigger content"},
      {"item", "slot, required", "one per menu row; accepts navigate/patch/href/variant"}
    ]} />
    """
  end
end
