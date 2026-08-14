defmodule MatriarchUIDocsWeb.Examples.Field do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      locale={@locale}
      title="Text field"
      description="The id is written once, on .field, and threaded to both field_label and the control via :let — for and id can never drift apart."
      class="flex-col items-stretch"
      code={
        ~S'''
        <.field :let={id} id="name">
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
      locale={@locale}
      title="Orientation"
      description="The content is vertical by default. Set orientation to horizontal for controls such as a checkbox and its label."
      code={
        ~S'''
        <.field :let={id} id="above">
          <.field_label for={id}>Label above</.field_label>
          <.checkbox id={id} name="above" />
        </.field>

        <.field :let={id} id="below">
          <.checkbox id={id} name="below" />
          <.field_label for={id}>Label below</.field_label>
        </.field>

        <.field :let={id} id="left" orientation="horizontal">
          <.field_label for={id}>Label left</.field_label>
          <.checkbox id={id} name="left" />
        </.field>

        <.field :let={id} id="right" orientation="horizontal">
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

      <.field :let={id} id="left" orientation="horizontal">
        <.field_label for={id}>Label left</.field_label>
        <.checkbox id={id} name="left" />
      </.field>

      <.field :let={id} id="right" orientation="horizontal">
        <.checkbox id={id} name="right" />
        <.field_label for={id}>Label right</.field_label>
      </.field>
    </.example>

    <.props_table
      locale={@locale}
      rows={[
        {"id", "string", "generates the id, handed to inner_block via :let"},
        {"field", "Phoenix.HTML.FormField",
         "derive id and validation errors from a form field instead of id"},
        {"errors", "list", "shown below the control with a danger border"},
        {"orientation", "horizontal | vertical", "content direction, vertical by default"},
        {"class", "string", "merged with the orientation classes via CN.cn/1"},
        {"field_label", "component",
         "styled <label for=...>; place it anywhere in the field's content"}
      ]}
    />
    """
  end
end
