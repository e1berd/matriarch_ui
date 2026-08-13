defmodule MatriarchUIDocsWeb.Examples.Select do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      title="Basic"
      code={
        ~S'''
        <.select
          id="role"
          name="role"
          value="admin"
          label="Role"
          options={[{"Admin", "admin"}, {"Editor", "editor"}, {"Viewer", "viewer"}]}
        />
        '''
      }
    >
      <div class="w-56">
        <.select
          id="role"
          name="role"
          value="admin"
          label="Role"
          options={[{"Admin", "admin"}, {"Editor", "editor"}, {"Viewer", "viewer"}]}
        />
      </div>
    </.example>

    <.props_table rows={[
      {"field", "Phoenix.HTML.FormField", "binds name/value from a form"},
      {"options", "list of {label, value}", "the selectable choices"},
      {"placeholder", "string", "shown when no option is selected"},
      {"label", "string", "optional label above the field"}
    ]} />
    """
  end
end
