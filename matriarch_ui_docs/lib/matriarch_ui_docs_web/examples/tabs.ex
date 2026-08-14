defmodule MatriarchUIDocsWeb.Examples.Tabs do
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
        <.tabs id="settings-tabs" default="general">
          <:tab value="general">General</:tab>
          <:tab value="billing">Billing</:tab>
          <:panel value="general">General settings go here.</:panel>
          <:panel value="billing">Billing settings go here.</:panel>
        </.tabs>
        '''
      }
    >
      <.tabs id="settings-tabs" default="general">
        <:tab value="general">General</:tab>
        <:tab value="billing">Billing</:tab>
        <:panel value="general">General settings go here.</:panel>
        <:panel value="billing">Billing settings go here.</:panel>
      </.tabs>
    </.example>

    <.props_table
      locale={@locale}
      rows={[
        {"id", "string, required", "root id"},
        {"default", "string, required", "value of the initially active tab"},
        {"tab", "slot, required", "one per tab trigger; needs a value attr"},
        {"panel", "slot, required", "one per panel; needs a matching value attr"}
      ]}
    />
    """
  end
end
