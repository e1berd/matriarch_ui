defmodule MatriarchUIDocsWeb.Examples.EmailInput do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      locale={@locale}
      title="Email field"
      class="flex-col items-stretch"
      code={
        ~S'''
        <.field :let={id} id="account-email">
          <.field_label for={id}>Email</.field_label>
          <.email_input id={id} name="email" placeholder="you@example.com" />
        </.field>
        '''
      }
    >
      <div class="w-80">
        <.field :let={id} id="account-email">
          <.field_label for={id}>Email</.field_label>
          <.email_input id={id} name="email" placeholder="you@example.com" />
        </.field>
      </div>
    </.example>

    <.example
      locale={@locale}
      title="Inside a group"
      code={
        ~S'''
        <.group label="Newsletter subscription" class="w-96">
          <.email_input id="newsletter-email" name="email" placeholder="you@example.com" />
          <.button>Subscribe</.button>
        </.group>
        '''
      }
    >
      <.group label="Newsletter subscription" class="w-96">
        <.email_input id="newsletter-email" name="email" placeholder="you@example.com" />
        <.button>Subscribe</.button>
      </.group>
    </.example>

    <.props_table
      locale={@locale}
      rows={[
        {"field", "Phoenix.HTML.FormField", "binds name/id/value and validation state"},
        {"rest", "global attrs", "supports autocomplete, required, multiple, and placeholder"},
        {"class", "string", "merged with the default input classes"}
      ]}
    />
    """
  end
end
