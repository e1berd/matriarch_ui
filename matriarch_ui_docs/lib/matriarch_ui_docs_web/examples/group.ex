defmodule MatriarchUIDocsWeb.Examples.Group do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      locale={@locale}
      title="Split button"
      description="Adjacent controls share their outer radius and collapse overlapping borders."
      code={
        ~S'''
        <.group label="Deployment actions">
          <.button variant="brand">Deploy</.button>
          <.button variant="brand" size="icon" aria-label="More deployment actions">
            <.icon name="caret-down" />
          </.button>
        </.group>
        '''
      }
    >
      <.group label="Deployment actions">
        <.button variant="brand">Deploy</.button>
        <.button variant="brand" size="icon" aria-label="More deployment actions">
          <.icon name="caret-down" />
        </.button>
      </.group>
    </.example>

    <.example
      locale={@locale}
      title="Input action"
      code={
        ~S'''
        <.group label="Invite by email" class="w-80">
          <.input name="email" placeholder="name@example.com" class="flex-1" />
          <.button>Invite</.button>
        </.group>
        '''
      }
    >
      <.group label="Invite by email" class="w-80">
        <.input name="email" placeholder="name@example.com" class="flex-1" />
        <.button>Invite</.button>
      </.group>
    </.example>

    <.props_table
      locale={@locale}
      rows={[
        {"orientation", "horizontal | vertical", "join direction, defaults to horizontal"},
        {"label", "string", "accessible name for role=group"},
        {"class", "string", "merged with the default group classes"}
      ]}
    />
    """
  end
end
