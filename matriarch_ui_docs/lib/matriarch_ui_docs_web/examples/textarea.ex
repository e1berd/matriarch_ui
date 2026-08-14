defmodule MatriarchUIDocsWeb.Examples.Textarea do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      locale={@locale}
      title="Basic"
      class="flex-col items-stretch"
      code={
        ~S'''
        <.field id="bio" :let={id}>
          <.field_label for={id}>Bio</.field_label>
          <.textarea id={id} name="bio" placeholder="Tell us about yourself" />
        </.field>
        '''
      }
    >
      <div class="w-96">
        <.field :let={id} id="bio">
          <.field_label for={id}>Bio</.field_label>
          <.textarea id={id} name="bio" placeholder="Tell us about yourself" />
        </.field>
      </div>
    </.example>

    <.props_table
      locale={@locale}
      rows={[
        {"field", "Phoenix.HTML.FormField", "binds name/id/value/invalid from a form"},
        {"invalid", "boolean", "shows the danger border and aria-invalid"},
        {"class", "string", "merged with the default classes via CN.cn/1"}
      ]}
    />
    """
  end
end
