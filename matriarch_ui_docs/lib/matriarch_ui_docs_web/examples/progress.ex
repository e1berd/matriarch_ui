defmodule MatriarchUIDocsWeb.Examples.Progress do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      locale={@locale}
      title="Determinate"
      class="flex-col items-stretch"
      code={
        ~S'''
        <.progressbar value={68.0} label="Upload progress" show_value class="max-w-md" />
        '''
      }
    >
      <.progressbar value={68.0} label="Upload progress" show_value class="max-w-md" />
    </.example>

    <.example
      locale={@locale}
      title="Indeterminate"
      class="flex-col items-stretch"
      code={
        ~S'''
        <.progressbar label="Preparing files" class="max-w-md" />
        '''
      }
    >
      <.progressbar label="Preparing files" class="max-w-md" />
    </.example>

    <.props_table
      locale={@locale}
      rows={[
        {"value", "float | nil", "current value; nil enables indeterminate animation"},
        {"max", "float", "maximum value, defaults to 100"},
        {"label", "string", "accessible progress label"},
        {"show_value", "boolean", "shows the label and calculated percentage"},
        {"class", "string", "merged with the default classes via CN.cn/1"}
      ]}
    />
    """
  end
end
