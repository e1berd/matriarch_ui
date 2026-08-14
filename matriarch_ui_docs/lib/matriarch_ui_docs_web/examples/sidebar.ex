defmodule MatriarchUIDocsWeb.Examples.Sidebar do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      locale={@locale}
      title="Basic"
      description="On desktop the trigger collapses it to icon-only width; below the md breakpoint it becomes an off-canvas drawer."
      class="items-stretch"
      code={
        ~S'''
        <div class="flex h-80 overflow-hidden rounded-mui-lg border border-mui-border">
          <.sidebar id="demo-sidebar">
            <.sidebar_header>
              <.sidebar_trigger for="demo-sidebar" />
              <span class="text-sm font-semibold text-mui-foreground group-data-[mui-state=closed]/sidebar:md:hidden">
                Acme Inc
              </span>
            </.sidebar_header>
            <.sidebar_content>
              <.sidebar_group label="Workspace">
                <.sidebar_menu_item navigate="#" active>
                  <:icon><.icon name="house" /></:icon>
                  Dashboard
                </.sidebar_menu_item>
                <.sidebar_menu_item navigate="#">
                  <:icon><.icon name="folders" /></:icon>
                  Projects
                </.sidebar_menu_item>
                <.sidebar_menu_item navigate="#">
                  <:icon><.icon name="gear" /></:icon>
                  Settings
                </.sidebar_menu_item>
              </.sidebar_group>
            </.sidebar_content>
            <.sidebar_footer>
              <.sidebar_menu_item navigate="#">
                <:icon><.icon name="sign-out" /></:icon>
                Log out
              </.sidebar_menu_item>
            </.sidebar_footer>
          </.sidebar>
          <div class="flex-1 p-4 text-sm text-mui-muted-foreground">Page content</div>
        </div>
        '''
      }
    >
      <div class="flex h-80 w-full overflow-hidden rounded-mui-lg border border-mui-border">
        <.sidebar id="demo-sidebar">
          <.sidebar_header>
            <.sidebar_trigger for="demo-sidebar" />
            <span class="text-sm font-semibold text-mui-foreground group-data-[mui-state=closed]/sidebar:md:hidden">
              Acme Inc
            </span>
          </.sidebar_header>
          <.sidebar_content>
            <.sidebar_group label="Workspace">
              <.sidebar_menu_item navigate="#" active>
                <:icon><.icon name="house" /></:icon>
                Dashboard
              </.sidebar_menu_item>
              <.sidebar_menu_item navigate="#">
                <:icon><.icon name="folders" /></:icon>
                Projects
              </.sidebar_menu_item>
              <.sidebar_menu_item navigate="#">
                <:icon><.icon name="gear" /></:icon>
                Settings
              </.sidebar_menu_item>
            </.sidebar_group>
          </.sidebar_content>
          <.sidebar_footer>
            <.sidebar_menu_item navigate="#">
              <:icon><.icon name="sign-out" /></:icon>
              Log out
            </.sidebar_menu_item>
          </.sidebar_footer>
        </.sidebar>
        <div class="flex-1 p-4 text-sm text-mui-muted-foreground">Page content</div>
      </div>
    </.example>

    <.props_table
      locale={@locale}
      rows={[
        {"sidebar", "id required",
         "root; group/sidebar carries data-mui-state for descendants to key off"},
        {"sidebar_trigger", "for required",
         "dispatches mui:toggle-sidebar to the sidebar with that id"},
        {"sidebar_group", "label", "optional heading, hidden while collapsed on desktop"},
        {"sidebar_menu_item", "navigate/patch/href, active, icon slot", "a nav link row"}
      ]}
    />
    """
  end
end
