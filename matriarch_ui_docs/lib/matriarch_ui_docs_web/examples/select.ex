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

    <.example
      title="Multiple"
      description="Selected values stay open for further choices and are submitted as a list. Click outside or press Escape to close."
      code={
        ~S'''
        <.field id="team-roles" :let={id}>
          <.field_label for={id}>Roles</.field_label>
          <.select id={id} name="roles" value={["admin", "editor"]} multiple>
            <:option value="admin">Admin</:option>
            <:option value="editor">Editor</:option>
            <:option value="viewer">Viewer</:option>
          </.select>
        </.field>
        '''
      }
    >
      <div class="w-56">
        <.field :let={id} id="team-roles">
          <.field_label for={id}>Roles</.field_label>
          <.select id={id} name="roles" value={["admin", "editor"]} multiple>
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
      {"multiple", "boolean",
       "submits a list, keeps the panel open and separates labels with commas"},
      {"invalid", "boolean", "shows the danger border and aria-invalid"}
    ]} />
    """
  end
end
