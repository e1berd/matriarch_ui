defmodule MatriarchUIDocsWeb.Examples.Card do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      title="With header and footer"
      code={
        ~S'''
        <.card class="w-80">
          <:header>Plan details</:header>
          <p class="text-mui-muted-foreground">You are currently on the Pro plan.</p>
          <:footer>
            <.button size="sm" variant="outline">Manage</.button>
          </:footer>
        </.card>
        '''
      }
    >
      <.card class="w-80">
        <:header>Plan details</:header>
        <p class="text-mui-muted-foreground">You are currently on the Pro plan.</p>
        <:footer>
          <.button size="sm" variant="outline">Manage</.button>
        </:footer>
      </.card>
    </.example>

    <.props_table rows={[
      {"header", "slot", "optional header, rendered above a divider"},
      {"footer", "slot", "optional footer, rendered below a divider"},
      {"class", "string", "merged with the default classes via CN.cn/1"}
    ]} />
    """
  end
end
