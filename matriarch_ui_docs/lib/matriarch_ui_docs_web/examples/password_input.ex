defmodule MatriarchUIDocsWeb.Examples.PasswordInput do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      title="Visibility toggle"
      class="flex-col items-stretch"
      code={
        ~S'''
        <.field :let={id} id="account-password">
          <.field_label for={id}>Password</.field_label>
          <.password_input id={id} name="password" placeholder="Enter password" />
        </.field>
        '''
      }
    >
      <div class="w-80">
        <.field :let={id} id="account-password">
          <.field_label for={id}>Password</.field_label>
          <.password_input id={id} name="password" placeholder="Enter password" />
        </.field>
      </div>
    </.example>

    <.props_table rows={[
      {"field", "Phoenix.HTML.FormField", "binds name/id/value and validation state"},
      {"show_label / hide_label", "string", "accessible labels for the visibility button"},
      {"rest", "global attrs", "supports autocomplete, minlength, maxlength, and required"},
      {"class", "string", "merged with the default input classes"}
    ]} />
    """
  end
end
