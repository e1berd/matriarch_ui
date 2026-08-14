defmodule MatriarchUIDocsWeb.Examples.ColorInput do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      title="Color field"
      class="flex-col items-stretch"
      code={
        ~S'''
        <.field :let={id} id="brand-color">
          <.field_label for={id}>Brand color</.field_label>
          <.color_input id={id} name="brand_color" value="#6c47ff" />
        </.field>
        '''
      }
    >
      <div class="w-72">
        <.field :let={id} id="brand-color">
          <.field_label for={id}>Brand color</.field_label>
          <.color_input id={id} name="brand_color" value="#6c47ff" />
        </.field>
      </div>
    </.example>

    <.example
      title="Inside a group"
      code={
        ~S'''
        <.group label="Accent color" class="w-80">
          <.color_input id="accent-color" name="accent_color" value="#846bff" />
          <.button>Apply</.button>
        </.group>
        '''
      }
    >
      <.group label="Accent color" class="w-80">
        <.color_input id="accent-color" name="accent_color" value="#846bff" />
        <.button>Apply</.button>
      </.group>
    </.example>

    <.props_table rows={[
      {"field", "Phoenix.HTML.FormField", "binds name/id/value and validation state"},
      {"value", "hex string", "six-digit CSS hex value shared by the text and native picker"},
      {"rest", "global attrs", "supports disabled, readonly, required, and placeholder"},
      {"class", "string", "merged with the root control classes"}
    ]} />
    """
  end
end
