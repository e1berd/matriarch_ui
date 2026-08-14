defmodule MatriarchUIDocsWeb.Examples.Field do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      title="Text field"
      description="The id is written once, on .field, and threaded to both field_label and the control via :let — for and id can never drift apart."
      class="flex-col items-stretch"
      code={
        ~S'''
        <.field id="name" :let={id}>
          <.field_label for={id}>Name</.field_label>
          <.input id={id} name="name" placeholder="John Doe" />
        </.field>
        '''
      }
    >
      <div class="w-72">
        <.field :let={id} id="name">
          <.field_label for={id}>Name</.field_label>
          <.input id={id} name="name" placeholder="John Doe" />
        </.field>
      </div>
    </.example>

    <.example
      title="Order and layout are yours to choose"
      description="Default is a vertical stack — write field_label first or last. Override class for a horizontal row."
      code={
        ~S'''
        <.field id="above" :let={id}>
          <.field_label for={id}>Label above</.field_label>
          <.checkbox id={id} name="above" />
        </.field>

        <.field id="below" :let={id}>
          <.checkbox id={id} name="below" />
          <.field_label for={id}>Label below</.field_label>
        </.field>

        <.field id="left" class="flex-row items-center gap-2" :let={id}>
          <.field_label for={id}>Label left</.field_label>
          <.checkbox id={id} name="left" />
        </.field>

        <.field id="right" class="flex-row items-center gap-2" :let={id}>
          <.checkbox id={id} name="right" />
          <.field_label for={id}>Label right</.field_label>
        </.field>
        '''
      }
    >
      <.field :let={id} id="above">
        <.field_label for={id}>Label above</.field_label>
        <.checkbox id={id} name="above" />
      </.field>

      <.field :let={id} id="below">
        <.checkbox id={id} name="below" />
        <.field_label for={id}>Label below</.field_label>
      </.field>

      <.field :let={id} id="left" class="flex-row items-center gap-2">
        <.field_label for={id}>Label left</.field_label>
        <.checkbox id={id} name="left" />
      </.field>

      <.field :let={id} id="right" class="flex-row items-center gap-2">
        <.checkbox id={id} name="right" />
        <.field_label for={id}>Label right</.field_label>
      </.field>
    </.example>

    <.example
      title="Grouped in a Fieldset"
      class="flex-col items-stretch"
      code={
        ~S'''
        <.fieldset>
          <:legend>Contact details</:legend>
          <.field id="fs-name" :let={id}>
            <.field_label for={id}>Name</.field_label>
            <.input id={id} name="name" placeholder="John Doe" />
          </.field>
          <.field id="fs-email" :let={id}>
            <.field_label for={id}>Email</.field_label>
            <.input id={id} type="email" name="email" placeholder="john@example.com" />
          </.field>
        </.fieldset>
        '''
      }
    >
      <div class="w-72">
        <.fieldset>
          <:legend>Contact details</:legend>
          <.field :let={id} id="fs-name">
            <.field_label for={id}>Name</.field_label>
            <.input id={id} name="name" placeholder="John Doe" />
          </.field>
          <.field :let={id} id="fs-email">
            <.field_label for={id}>Email</.field_label>
            <.input id={id} type="email" name="email" placeholder="john@example.com" />
          </.field>
        </.fieldset>
      </div>
    </.example>

    <.props_table rows={[
      {"id", "string", "generates the id, handed to inner_block via :let"},
      {"field", "Phoenix.HTML.FormField",
       "derive id and validation errors from a form field instead of id"},
      {"errors", "list", "shown below the control with a danger border"},
      {"class", "string",
       "merged with the default classes via CN.cn/1 — flex flex-col gap-1.5 by default"},
      {"field_label", "component",
       "styled <label for=...>; place it anywhere in the field's content"},
      {"fieldset.legend", "slot", "optional heading above a group of fields"}
    ]} />
    """
  end
end
