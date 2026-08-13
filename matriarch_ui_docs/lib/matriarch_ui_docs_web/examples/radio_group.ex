defmodule MatriarchUIDocsWeb.Examples.RadioGroup do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      title="Basic"
      code={
        ~S'''
        <.radio_group
          name="plan"
          id="plan"
          value="pro"
          label="Plan"
          options={[{"Free", "free"}, {"Pro", "pro"}, {"Team", "team"}]}
        />
        '''
      }
    >
      <.radio_group
        name="plan"
        id="plan"
        value="pro"
        label="Plan"
        options={[{"Free", "free"}, {"Pro", "pro"}, {"Team", "team"}]}
      />
    </.example>

    <.props_table rows={[
      {"field", "Phoenix.HTML.FormField", "binds name/id/value from a form"},
      {"options", "list of {label, value}", "the radio choices"},
      {"orientation", "vertical | horizontal", "layout of the options"},
      {"label", "string", "optional legend above the group"}
    ]} />
    """
  end
end
