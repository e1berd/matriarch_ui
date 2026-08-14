defmodule MatriarchUIDocsWeb.Examples.FileUpload do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      title="Field usage"
      class="flex-col items-stretch"
      code={
        ~S'''
        <.field :let={id} id="resume">
          <.field_label for={id}>Resume</.field_label>
          <.file_upload id={id} name="resume" accept=".pdf,.doc,.docx" />
        </.field>
        '''
      }
    >
      <div class="w-full max-w-lg">
        <.field :let={id} id="resume">
          <.field_label for={id}>Resume</.field_label>
          <.file_upload id={id} name="resume" accept=".pdf,.doc,.docx" />
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
          empty_text="PDF, PNG, or JPEG"
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
          empty_text="PDF, PNG, or JPEG"
        />
      </div>
    </.example>

    <.props_table rows={[
      {"field", "Phoenix.HTML.FormField", "binds name/id and validation state from a form"},
      {"multiple", "boolean", "submits the input name with [] and accepts multiple files"},
      {"prompt / empty_text", "string", "labels for the picker action and empty selection"},
      {"class", "string", "merged with the default classes via CN.cn/1"}
    ]} />
    """
  end
end
