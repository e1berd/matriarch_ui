defmodule MatriarchUIDocsWeb.Examples.Accordion do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      locale={@locale}
      title="Single (default)"
      description="Opening one item closes the others."
      code={
        ~S'''
        <.accordion id="faq" default={["setup"]}>
          <:item value="setup" title="Does matriarchUI need npm?">
            No — everything ships as a self-contained colocated hook.
          </:item>
          <:item value="theme" title="How do I re-theme it?">
            Override any <code>--color-mui-*</code> variable in your own app.css.
          </:item>
          <:item value="deps" title="What does it depend on?">
            Just Phoenix LiveView and Tailwind v4.
          </:item>
        </.accordion>
        '''
      }
    >
      <div class="w-full max-w-md">
        <.accordion id="faq" default={["setup"]}>
          <:item value="setup" title="Does matriarchUI need npm?">
            No — everything ships as a self-contained colocated hook.
          </:item>
          <:item value="theme" title="How do I re-theme it?">
            Override any <code>--color-mui-*</code> variable in your own app.css.
          </:item>
          <:item value="deps" title="What does it depend on?">
            Just Phoenix LiveView and Tailwind v4.
          </:item>
        </.accordion>
      </div>
    </.example>

    <.props_table
      locale={@locale}
      rows={[
        {"id", "string, required", "unique id, prefixes every trigger/panel id"},
        {"type", "single | multiple", "single (default) closes siblings when one opens"},
        {"default", "list of strings", "item values open on first render"},
        {"item", "slot, required", "one per row; takes value and title, content is the panel body"}
      ]}
    />
    """
  end
end
