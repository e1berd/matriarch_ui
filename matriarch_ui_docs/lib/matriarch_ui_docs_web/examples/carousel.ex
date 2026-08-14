defmodule MatriarchUIDocsWeb.Examples.Carousel do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      title="Basic"
      code={
        ~S'''
        <.carousel id="gallery" label="Feature highlights">
          <:slide>
            <div class="flex h-40 items-center justify-center bg-mui-primary-subtle text-mui-primary-subtle-foreground">
              Slide 1
            </div>
          </:slide>
          <:slide>
            <div class="flex h-40 items-center justify-center bg-mui-accent-subtle text-mui-accent-subtle-foreground">
              Slide 2
            </div>
          </:slide>
          <:slide>
            <div class="flex h-40 items-center justify-center bg-mui-success-subtle text-mui-success">
              Slide 3
            </div>
          </:slide>
        </.carousel>
        '''
      }
    >
      <div class="w-full max-w-md">
        <.carousel id="gallery" label="Feature highlights">
          <:slide>
            <div class="flex h-40 items-center justify-center bg-mui-primary-subtle text-mui-primary-subtle-foreground">
              Slide 1
            </div>
          </:slide>
          <:slide>
            <div class="flex h-40 items-center justify-center bg-mui-accent-subtle text-mui-accent-subtle-foreground">
              Slide 2
            </div>
          </:slide>
          <:slide>
            <div class="flex h-40 items-center justify-center bg-mui-success-subtle text-mui-success">
              Slide 3
            </div>
          </:slide>
        </.carousel>
      </div>
    </.example>

    <.props_table rows={[
      {"id", "string, required", "unique id for the track/hook"},
      {"label", "string", "aria-label for the region, defaults to \"Carousel\""},
      {"slide", "slot, required", "one per slide, each takes the track's full width"}
    ]} />
    """
  end
end
