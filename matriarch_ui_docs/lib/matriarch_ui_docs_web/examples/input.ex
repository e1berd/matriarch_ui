defmodule MatriarchUIDocsWeb.Examples.Input do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      locale={@locale}
      title="Basic"
      class="flex-col items-stretch"
      code={
        ~S'''
        <.field id="email" :let={id}>
          <.field_label for={id}>Email</.field_label>
          <.input id={id} name="email" type="email" placeholder="you@example.com" />
        </.field>
        '''
      }
    >
      <div class="w-72">
        <.field :let={id} id="email">
          <.field_label for={id}>Email</.field_label>
          <.input id={id} name="email" type="email" placeholder="you@example.com" />
        </.field>
      </div>
    </.example>

    <.example
      locale={@locale}
      title="With error"
      class="flex-col items-stretch"
      code={
        ~S'''
        <.field id="handle" errors={["only letters and numbers"]} :let={id}>
          <.field_label for={id}>Handle</.field_label>
          <.input id={id} name="handle" value="!!" invalid={true} />
        </.field>
        '''
      }
    >
      <div class="w-72">
        <.field :let={id} id="handle" errors={["only letters and numbers"]}>
          <.field_label for={id}>Handle</.field_label>
          <.input id={id} name="handle" value="!!" invalid={true} />
        </.field>
      </div>
    </.example>

    <.props_table
      locale={@locale}
      rows={[
        {"field", "Phoenix.HTML.FormField", "binds name/id/value/invalid from a form"},
        {"type", "string", "any input type, defaults to \"text\""},
        {"invalid", "boolean", "shows the danger border and aria-invalid"},
        {"class", "string", "merged with the default classes via CN.cn/1"}
      ]}
    />

    <p class="text-sm text-mui-muted-foreground">
      <%= if @locale == "ru" do %>
        Используйте вместе с <code>&lt;.field&gt;</code>, чтобы добавить подпись и ошибки валидации.
        Подробнее на странице компонента Field.
      <% else %>
        Pair with <code>&lt;.field&gt;</code>
        for a label and validation errors — see the Field docs page.
      <% end %>
    </p>
    """
  end
end
