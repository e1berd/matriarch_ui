defmodule MatriarchUIDocsWeb.Examples.Input do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      title="Basic"
      class="flex-col items-stretch"
      code={
        ~S'''
        <.input name="email" id="email" type="email" label="Email" placeholder="you@example.com" />
        '''
      }
    >
      <div class="w-72">
        <.input name="email" id="email" type="email" label="Email" placeholder="you@example.com" />
      </div>
    </.example>

    <.example
      title="With error"
      class="flex-col items-stretch"
      code={
        ~S'''
        <.input name="handle" id="handle" label="Handle" value="!!" errors={["only letters and numbers"]} />
        '''
      }
    >
      <div class="w-72">
        <.input
          name="handle"
          id="handle"
          label="Handle"
          value="!!"
          errors={["only letters and numbers"]}
        />
      </div>
    </.example>

    <.props_table rows={[
      {"field", "Phoenix.HTML.FormField", "binds name/id/value/errors from a form"},
      {"type", "string", "any input type, defaults to \"text\""},
      {"label", "string", "optional label above the field"},
      {"errors", "list", "shown below the field with a danger border"},
      {"class", "string", "merged with the default classes via CN.cn/1"}
    ]} />
    """
  end
end
