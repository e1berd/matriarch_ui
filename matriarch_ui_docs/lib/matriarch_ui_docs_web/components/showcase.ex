defmodule MatriarchUIDocsWeb.Showcase do
  @moduledoc "Live preview + source snippet pairing used on every component doc page."
  use Phoenix.Component
  alias MatriarchUIDocsWeb.DocsI18n

  attr :locale, :string, default: "en"
  attr :title, :string, required: true
  attr :description, :string, default: nil
  attr :code, :string, required: true
  attr :class, :string, default: nil
  slot :inner_block, required: true

  def example(assigns) do
    ~H"""
    <section class="flex flex-col gap-3">
      <div>
        <h3 class="text-sm font-semibold text-mui-foreground">
          {DocsI18n.t(@locale, @title)}
        </h3>
        <p :if={@description} class="text-sm text-mui-muted-foreground">
          {DocsI18n.t(@locale, @description)}
        </p>
      </div>
      <div class={[
        "flex flex-wrap items-center gap-3 rounded-mui-lg border border-mui-border bg-mui-surface p-5 shadow-mui-xs",
        @class
      ]}>
        {render_slot(@inner_block)}
      </div>
      <pre class="overflow-x-auto rounded-mui-lg border border-mui-border bg-mui-surface-hover p-3.5 text-xs text-mui-foreground"><code phx-no-curly-interpolation><%= String.trim(@code) %></code></pre>
    </section>
    """
  end

  attr :locale, :string, default: "en"
  attr :rows, :list, required: true, doc: "list of `{name, type, description}` tuples"

  def props_table(assigns) do
    ~H"""
    <div class="overflow-x-auto rounded-mui-lg border border-mui-border">
      <table class="w-full text-left text-sm">
        <thead class="bg-mui-surface-hover text-xs uppercase text-mui-subtle-foreground">
          <tr>
            <th class="px-4 py-2 font-medium">{DocsI18n.t(@locale, "Attr")}</th>
            <th class="px-4 py-2 font-medium">{DocsI18n.t(@locale, "Type")}</th>
            <th class="px-4 py-2 font-medium">{DocsI18n.t(@locale, "Description")}</th>
          </tr>
        </thead>
        <tbody>
          <tr :for={{name, type, description} <- @rows} class="border-t border-mui-border">
            <td class="whitespace-nowrap px-4 py-2 font-mono text-mui-primary">{name}</td>
            <td class="whitespace-nowrap px-4 py-2 text-mui-muted-foreground">{type}</td>
            <td class="px-4 py-2 text-mui-foreground">{DocsI18n.t(@locale, description)}</td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end
end
