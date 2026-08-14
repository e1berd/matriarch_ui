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
          <.card_header>
            <.card_title>Plan details</.card_title>
            <.card_description>You are currently on the Pro plan.</.card_description>
          </.card_header>
          <.card_content>
            <p class="text-mui-muted-foreground">Renews on the 1st of every month.</p>
          </.card_content>
          <.card_footer>
            <.button size="sm" variant="outline">Manage</.button>
          </.card_footer>
        </.card>
        '''
      }
    >
      <.card class="w-80">
        <.card_header>
          <.card_title>Plan details</.card_title>
          <.card_description>You are currently on the Pro plan.</.card_description>
        </.card_header>
        <.card_content>
          <p class="text-mui-muted-foreground">Renews on the 1st of every month.</p>
        </.card_content>
        <.card_footer>
          <.button size="sm" variant="outline">Manage</.button>
        </.card_footer>
      </.card>
    </.example>

    <.props_table rows={[
      {"card", "component", "bare surface — rounded-mui-lg border bg-mui-surface shadow-mui-sm"},
      {"card_header", "component", "flex column, gap-1.5, meant to hold card_title/card_description"},
      {"card_title", "component", "text-sm font-semibold"},
      {"card_description", "component", "text-sm text-mui-muted-foreground"},
      {"card_content", "component", "main body, no top padding (follows card_header)"},
      {"card_footer", "component", "flex row, gap-2, no top padding (follows card_content)"}
    ]} />
    """
  end
end
