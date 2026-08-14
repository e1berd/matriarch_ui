defmodule MatriarchUIDocsWeb.Examples.Spinner do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      locale={@locale}
      title="Sizes"
      code={
        ~S'''
        <.spinner size="sm" label="Loading small item" />
        <.spinner size="md" label="Loading item" />
        <.spinner size="lg" label="Loading large item" />
        '''
      }
    >
      <.spinner size="sm" label="Loading small item" />
      <.spinner size="md" label="Loading item" />
      <.spinner size="lg" label="Loading large item" />
    </.example>

    <.example
      locale={@locale}
      title="In a button"
      code={
        ~S'''
        <.button disabled>
          <.spinner size="sm" label="Saving" class="text-current" />
          Saving
        </.button>
        '''
      }
    >
      <.button disabled>
        <.spinner size="sm" label="Saving" class="text-current" /> Saving
      </.button>
    </.example>

    <.props_table
      locale={@locale}
      rows={[
        {"size", "sm | md | lg", "indicator size, defaults to md"},
        {"label", "string", "accessible status label"},
        {"class", "string", "merged with the default classes via CN.cn/1"}
      ]}
    />
    """
  end
end
