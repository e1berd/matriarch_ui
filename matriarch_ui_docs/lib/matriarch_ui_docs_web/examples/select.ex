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
        <.select id="role" name="role" value="admin" label="Role">
          <:option value="admin">Admin</:option>
          <:option value="editor">Editor</:option>
          <:option value="viewer">Viewer</:option>
        </.select>
        '''
      }
    >
      <div class="w-56">
        <.select id="role" name="role" value="admin" label="Role">
          <:option value="admin">Admin</:option>
          <:option value="editor">Editor</:option>
          <:option value="viewer">Viewer</:option>
        </.select>
      </div>
    </.example>

    <.props_table rows={[
      {"field", "Phoenix.HTML.FormField", "binds name/value from a form"},
      {"option", "slot, required",
       "one per choice; takes value (required) and label (optional plain-text mirror)"},
      {"placeholder", "string", "shown when no option is selected"},
      {"label", "string", "optional label above the field"}
    ]} />
    """
  end
end
