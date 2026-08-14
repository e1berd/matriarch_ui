defmodule MatriarchUIDocsWeb.Examples.FileUpload do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      title="Choose or drop a file"
      class="flex-col items-stretch"
      code={
        ~S'''
        <.field :let={id} id="resume">
          <.field_label for={id}>Resume</.field_label>
          <.file_upload id={id} name="resume" accept=".pdf,.doc,.docx" event="resume-selected" />
        </.field>
        '''
      }
    >
      <div class="w-full max-w-lg">
        <.field :let={id} id="resume">
          <.field_label for={id}>Resume</.field_label>
          <.file_upload id={id} name="resume" accept=".pdf,.doc,.docx" event="resume-selected" />
        </.field>
      </div>
    </.example>

    <.example
      title="Multiple files"
      class="flex-col items-stretch"
      code={
        ~S'''
        <.file_upload
          id="attachments"
          name="attachments"
          multiple
          prompt="Add files"
          description="PDF, PNG, or JPEG"
        />
        '''
      }
    >
      <div class="w-full max-w-lg">
        <.file_upload
          id="attachments"
          name="attachments"
          multiple
          prompt="Add files"
          description="PDF, PNG, or JPEG"
        />
      </div>
    </.example>

    <.props_table rows={[
      {"field", "Phoenix.HTML.FormField", "binds name/id and validation state from a form"},
      {"multiple", "boolean", "accepts one file by default or several files when enabled"},
      {"event", "string", "optional LiveView event receiving selected file metadata"},
      {"prompt / description", "string", "static drop-zone copy; selected files are not rendered"},
      {"class", "string", "merged with the default classes via CN.cn/1"}
    ]} />
    """
  end
end
