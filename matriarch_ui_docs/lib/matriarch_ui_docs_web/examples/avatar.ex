defmodule MatriarchUIDocsWeb.Examples.Avatar do
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
        <.avatar size="xs" initials="AB" />
        <.avatar size="sm" initials="AB" />
        <.avatar size="md" initials="AB" />
        <.avatar size="lg" initials="AB" />
        <.avatar size="xl" initials="AB" />
        '''
      }
    >
      <.avatar size="xs" initials="AB" />
      <.avatar size="sm" initials="AB" />
      <.avatar size="md" initials="AB" />
      <.avatar size="lg" initials="AB" />
      <.avatar size="xl" initials="AB" />
    </.example>

    <.props_table
      locale={@locale}
      rows={[
        {"src", "string", "image URL; falls back to initials when omitted"},
        {"initials", "string", "shown when no src is given"},
        {"size", "xs | sm | md | lg | xl", "diameter"},
        {"class", "string", "merged with the default classes via CN.cn/1"}
      ]}
    />
    """
  end
end
