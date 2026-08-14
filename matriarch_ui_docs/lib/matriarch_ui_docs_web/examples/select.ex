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
        <.field id="role" :let={id}>
          <.field_label for={id}>Role</.field_label>
          <.select id={id} name="role" value="admin">
            <:option value="admin">Admin</:option>
            <:option value="editor">Editor</:option>
            <:option value="viewer">Viewer</:option>
          </.select>
        </.field>
        '''
      }
    >
      <div class="w-56">
        <.field :let={id} id="role">
          <.field_label for={id}>Role</.field_label>
          <.select id={id} name="role" value="admin">
            <:option value="admin">Admin</:option>
            <:option value="editor">Editor</:option>
            <:option value="viewer">Viewer</:option>
          </.select>
        </.field>
      </div>
    </.example>

    <.props_table rows={[
      {"field", "Phoenix.HTML.FormField", "binds name/value/invalid from a form"},
      {"option", "slot, required",
       "one per choice; takes value (required) and label (optional plain-text mirror)"},
      {"placeholder", "string", "shown when no option is selected"},
      {"invalid", "boolean", "shows the danger border and aria-invalid"}
    ]} />
    """
  end
end
