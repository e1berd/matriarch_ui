defmodule MatriarchUIDocsWeb.Examples.DateInput do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      title="Per-input date format"
      class="flex-col items-stretch"
      code={
        ~S'''
        <.field :let={id} id="birthday">
          <.field_label for={id}>Birthday</.field_label>
          <.date_input
            id={id}
            name="birthday"
            value={~D[1994-05-23]}
            min={~D[1900-01-01]}
            max={Date.utc_today()}
            format="DD.MM.YYYY"
          />
        </.field>
        '''
      }
    >
      <div class="w-72">
        <.field :let={id} id="birthday">
          <.field_label for={id}>Birthday</.field_label>
          <.date_input
            id={id}
            name="birthday"
            value={~D[1994-05-23]}
            min={~D[1900-01-01]}
            max={Date.utc_today()}
            format="DD.MM.YYYY"
          />
        </.field>
      </div>
    </.example>

    <.example
      title="Global default"
      description="Set the default once in the consuming application's config. An input-level format always takes precedence."
      code={
        ~S'''
        config :matriarch_ui, date_format: "MM/DD/YYYY"
        '''
      }
    >
      <code class="text-sm text-mui-foreground">
        config :matriarch_ui, date_format: "MM/DD/YYYY"
      </code>
    </.example>

    <.props_table rows={[
      {"field", "Phoenix.HTML.FormField", "binds name/id/value and validation state"},
      {"format", "string", "visual token order and separator, such as DD.MM.YYYY"},
      {"min / max", "Date | ISO string", "inclusive date constraints"},
      {"rest", "global attrs", "supports disabled, readonly, and required"},
      {"class", "string", "merged with the default input classes"}
    ]} />
    """
  end
end
