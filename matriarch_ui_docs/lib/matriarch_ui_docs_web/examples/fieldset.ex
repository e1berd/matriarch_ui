defmodule MatriarchUIDocsWeb.Examples.Fieldset do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      title="Related controls"
      description="Fieldset gives a group of related fields native semantics. Its legend names the group, while every field retains its own label."
      class="flex-col items-stretch"
      code={
        ~S'''
        <.fieldset>
          <:legend>Notification channels</:legend>
          <.field :let={id} id="notify-email" orientation="horizontal">
            <.checkbox id={id} name="notification_email" />
            <.field_label for={id}>Email</.field_label>
          </.field>
          <.field :let={id} id="notify-sms" orientation="horizontal">
            <.checkbox id={id} name="notification_sms" />
            <.field_label for={id}>SMS</.field_label>
          </.field>
        </.fieldset>
        '''
      }
    >
      <div class="w-72">
        <.fieldset>
          <:legend>Notification channels</:legend>
          <.field :let={id} id="notify-email" orientation="horizontal">
            <.checkbox id={id} name="notification_email" />
            <.field_label for={id}>Email</.field_label>
          </.field>
          <.field :let={id} id="notify-sms" orientation="horizontal">
            <.checkbox id={id} name="notification_sms" />
            <.field_label for={id}>SMS</.field_label>
          </.field>
        </.fieldset>
      </div>
    </.example>

    <.props_table rows={[
      {"legend", "slot", "optional native legend that names the control group"},
      {"class", "string", "merged with the vertical group layout via CN.cn/1"},
      {"rest", "global attrs", "supports native fieldset attributes such as disabled"}
    ]} />
    """
  end
end
