defmodule MatriarchUIDocsWeb.Examples.Alert do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      locale={@locale}
      title="Variants"
      class="flex-col items-stretch"
      code={
        ~S'''
        <.alert>
          <.alert_title>Heads up</.alert_title>
          <.alert_description>This is an informational message.</.alert_description>
        </.alert>
        <.alert variant="info">
          <.alert_title>Note</.alert_title>
          <.alert_description>New features are available in settings.</.alert_description>
        </.alert>
        <.alert variant="success">
          <.alert_title>Saved</.alert_title>
          <.alert_description>Your changes were saved.</.alert_description>
        </.alert>
        <.alert variant="warning">
          <.alert_title>Careful</.alert_title>
          <.alert_description>This action can't be undone.</.alert_description>
        </.alert>
        <.alert variant="danger">
          <.alert_title>Error</.alert_title>
          <.alert_description>Something went wrong.</.alert_description>
        </.alert>
        '''
      }
    >
      <.alert>
        <.alert_title>Heads up</.alert_title>
        <.alert_description>This is an informational message.</.alert_description>
      </.alert>
      <.alert variant="info">
        <.alert_title>Note</.alert_title>
        <.alert_description>New features are available in settings.</.alert_description>
      </.alert>
      <.alert variant="success">
        <.alert_title>Saved</.alert_title>
        <.alert_description>Your changes were saved.</.alert_description>
      </.alert>
      <.alert variant="warning">
        <.alert_title>Careful</.alert_title>
        <.alert_description>This action can't be undone.</.alert_description>
      </.alert>
      <.alert variant="danger">
        <.alert_title>Error</.alert_title>
        <.alert_description>Something went wrong.</.alert_description>
      </.alert>
    </.example>

    <.props_table
      locale={@locale}
      rows={[
        {"variant", "default | info | success | warning | danger", "visual style and default icon"},
        {"icon", "slot", "overrides the variant's default icon"},
        {"class", "string", "merged with the default classes via CN.cn/1"}
      ]}
    />
    """
  end
end
