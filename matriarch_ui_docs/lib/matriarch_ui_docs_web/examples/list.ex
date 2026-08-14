defmodule MatriarchUIDocsWeb.Examples.List do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      locale={@locale}
      title="Custom items"
      class="flex-col items-stretch"
      code={
        ~S'''
        <.list class="w-full max-w-lg">
          <.list_item title="Olivia Martin" subtitle="Product designer">
            <:media><.avatar initials="OM" /></:media>
            <:trailing>
              <.button variant="ghost" size="icon" aria-label="Open Olivia Martin">
                <.icon name="arrow-right" />
              </.button>
            </:trailing>
          </.list_item>
          <.list_item title="Quarterly report" subtitle="PDF · 2 MB">
            <:media>
              <span class="flex size-9 items-center justify-center rounded-mui-md bg-mui-primary-subtle">
                <.icon name="file" />
              </span>
            </:media>
            <:trailing>
              <.button variant="ghost" size="icon" aria-label="Download report">
                <.icon name="arrow-right" />
              </.button>
              <.button variant="ghost" size="icon" aria-label="Delete report">
                <.icon name="trash" />
              </.button>
            </:trailing>
          </.list_item>
        </.list>
        '''
      }
    >
      <.list class="w-full max-w-lg">
        <.list_item title="Olivia Martin" subtitle="Product designer">
          <:media><.avatar initials="OM" /></:media>
          <:trailing>
            <.button variant="ghost" size="icon" aria-label="Open Olivia Martin">
              <.icon name="arrow-right" />
            </.button>
          </:trailing>
        </.list_item>
        <.list_item title="Quarterly report" subtitle="PDF · 2 MB">
          <:media>
            <span class="flex size-9 items-center justify-center rounded-mui-md bg-mui-primary-subtle">
              <.icon name="file" />
            </span>
          </:media>
          <:trailing>
            <.button variant="ghost" size="icon" aria-label="Download report">
              <.icon name="arrow-right" />
            </.button>
            <.button variant="ghost" size="icon" aria-label="Delete report">
              <.icon name="trash" />
            </.button>
          </:trailing>
        </.list_item>
      </.list>
    </.example>

    <.props_table
      locale={@locale}
      rows={[
        {"list.as", "ul | ol", "semantic list element, defaults to ul"},
        {"list_item.title / subtitle", "string", "optional primary and secondary text"},
        {"list_item.media", "slot", "optional image, avatar, icon, or custom leading content"},
        {"list_item.trailing", "slot", "any trailing content, including one or several buttons"}
      ]}
    />
    """
  end
end
