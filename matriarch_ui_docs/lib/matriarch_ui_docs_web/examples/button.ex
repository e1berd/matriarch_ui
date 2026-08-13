defmodule MatriarchUIDocsWeb.Examples.Button do
  use Phoenix.Component

  use Phoenix.VerifiedRoutes,
    endpoint: MatriarchUIDocsWeb.Endpoint,
    router: MatriarchUIDocsWeb.Router

  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      title="Variants"
      code={
        ~S'''
        <.button variant="solid">Solid</.button>
        <.button variant="outline">Outline</.button>
        <.button variant="ghost">Ghost</.button>
        <.button variant="soft">Soft</.button>
        <.button variant="destructive">Destructive</.button>
        <.button variant="link">Link</.button>
        '''
      }
    >
      <.button variant="solid">Solid</.button>
      <.button variant="outline">Outline</.button>
      <.button variant="ghost">Ghost</.button>
      <.button variant="soft">Soft</.button>
      <.button variant="destructive">Destructive</.button>
      <.button variant="link">Link</.button>
    </.example>

    <.example
      title="Sizes"
      code={
        ~S'''
        <.button size="sm">Small</.button>
        <.button size="md">Medium</.button>
        <.button size="lg">Large</.button>
        '''
      }
    >
      <.button size="sm">Small</.button>
      <.button size="md">Medium</.button>
      <.button size="lg">Large</.button>
    </.example>

    <.example
      title="Loading"
      code={
        ~S'''
        <.button loading>Saving…</.button>
        '''
      }
    >
      <.button loading>Saving…</.button>
    </.example>

    <.example
      title="As a link"
      code={
        ~S'''
        <.button navigate={~p"/docs"}>Browse the docs</.button>
        '''
      }
    >
      <.button navigate={~p"/docs"}>Browse the docs</.button>
    </.example>

    <.props_table rows={[
      {"variant", "solid | outline | ghost | soft | destructive | link", "visual style"},
      {"size", "sm | md | lg | icon", "height and padding"},
      {"loading", "boolean", "shows a spinner and disables the button"},
      {"disabled", "boolean", "disables the button"},
      {"navigate / patch / href", "string", "renders as <.link> instead of <button>"},
      {"class", "string", "merged with the default classes via CN.cn/1"}
    ]} />
    """
  end
end
