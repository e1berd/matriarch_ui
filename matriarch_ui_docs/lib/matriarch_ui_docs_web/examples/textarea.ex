defmodule MatriarchUIDocsWeb.Examples.Textarea do
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
        <.textarea name="bio" id="bio" label="Bio" placeholder="Tell us about yourself" />
        '''
      }
    >
      <div class="w-96">
        <.textarea name="bio" id="bio" label="Bio" placeholder="Tell us about yourself" />
      </div>
    </.example>

    <.props_table rows={[
      {"field", "Phoenix.HTML.FormField", "binds name/id/value/errors from a form"},
      {"label", "string", "optional label above the field"},
      {"errors", "list", "shown below the field with a danger border"},
      {"class", "string", "merged with the default classes via CN.cn/1"}
    ]} />
    """
  end
end
