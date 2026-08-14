defmodule MatriarchUIDocsWeb.Examples.Card do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      locale={@locale}
      title="Deployment"
      description="The Vuzeno Card example reproduced with matriarchUI primitives."
      code={
        ~S'''
        <.card class="w-[350px]">
          <.card_header>
            <.card_title>Marketing-site</.card_title>
            <.card_description>Production environment</.card_description>
          </.card_header>
          <.card_content class="grid gap-2 text-sm">
            <div class="flex items-center justify-between">
              <span class="flex items-center gap-2 text-mui-muted-foreground">
                <.icon name="clock" class="size-3.5" />
                Last deployment
              </span>
              <span>2 min ago</span>
            </div>
            <div class="flex items-center justify-between">
              <span class="flex items-center gap-2 text-mui-muted-foreground">
                <.icon name="git-branch" class="size-3.5" />
                Branch
              </span>
              <span>main</span>
            </div>
            <div class="flex items-center justify-between">
              <span class="flex items-center gap-2 text-mui-muted-foreground">
                <.icon name="timer" class="size-3.5" />
                Duration
              </span>
              <span>42s</span>
            </div>
            <.button class="mt-2 w-full">Redeploy</.button>
          </.card_content>
          <.card_footer class="gap-1.5">
            <div class="size-2 shrink-0 rounded-mui-full bg-mui-success" />
            <div class="flex w-full justify-between text-xs">
              <span class="font-medium">Deployed</span>
              <span class="text-mui-muted-foreground">2 min ago</span>
            </div>
          </.card_footer>
        </.card>
        '''
      }
    >
      <.card class="w-[350px]">
        <.card_header>
          <.card_title>Marketing-site</.card_title>
          <.card_description>Production environment</.card_description>
        </.card_header>
        <.card_content class="grid gap-2 text-sm">
          <div class="flex items-center justify-between">
            <span class="flex items-center gap-2 text-mui-muted-foreground">
              <.icon name="clock" class="size-3.5" /> Last deployment
            </span>
            <span>2 min ago</span>
          </div>
          <div class="flex items-center justify-between">
            <span class="flex items-center gap-2 text-mui-muted-foreground">
              <.icon name="git-branch" class="size-3.5" /> Branch
            </span>
            <span>main</span>
          </div>
          <div class="flex items-center justify-between">
            <span class="flex items-center gap-2 text-mui-muted-foreground">
              <.icon name="timer" class="size-3.5" /> Duration
            </span>
            <span>42s</span>
          </div>
          <.button class="mt-2 w-full">Redeploy</.button>
        </.card_content>
        <.card_footer class="gap-1.5">
          <div class="size-2 shrink-0 rounded-mui-full bg-mui-success" />
          <div class="flex w-full justify-between text-xs">
            <span class="font-medium">Deployed</span>
            <span class="text-mui-muted-foreground">2 min ago</span>
          </div>
        </.card_footer>
      </.card>
    </.example>

    <.example
      locale={@locale}
      title="Sign in"
      description="A polished authentication layout composed from Card, Button, Field and Input primitives."
      code={sign_in_code()}
    >
      <.card class="mui-card-elevated w-full max-w-[25rem] overflow-hidden border-mui-card-border bg-mui-card p-0">
        <.card_header class="items-center gap-1 px-10 pt-8 pb-6 text-center">
          <.card_title class="text-base tracking-normal">Sign in to your account</.card_title>
          <.card_description>Welcome back! Please sign in to continue</.card_description>
        </.card_header>

        <.card_content class="grid gap-6 rounded-none border-0 bg-transparent px-10 pt-0 pb-8 mui-dark:bg-transparent">
          <div class="grid grid-cols-2 gap-2">
            <.button variant="outline" class="mui-social-button w-full border-transparent">
              <:icon>
                <.icon name="github-logo" />
              </:icon>
              GitHub
            </.button>
            <.button variant="outline" class="mui-social-button w-full border-transparent">
              <:icon>
                <.icon name="google-logo" />
              </:icon>
              Google
            </.button>
          </div>

          <div class="flex items-center gap-4 text-sm text-mui-muted-foreground">
            <div class="h-px flex-1 bg-mui-card-border" />
            <span>or</span>
            <div class="h-px flex-1 bg-mui-card-border" />
          </div>

          <.form for={to_form(%{}, as: :sign_in)} id="sign-in-form" class="grid gap-5">
            <.field :let={id} id="sign-in-email">
              <.field_label for={id}>Email address</.field_label>
              <.input
                id={id}
                name="email"
                type="email"
                placeholder="Enter your email address"
                autocomplete="email"
              />
            </.field>
            <.button type="submit" variant="brand" class="w-full">
              Continue <.icon name="arrow-right" class="size-3" />
            </.button>
          </.form>

          <.button variant="link" class="mx-auto text-mui-brand">Use passkey instead</.button>
        </.card_content>

        <.card_footer class="justify-center border-t border-mui-card-border bg-mui-card-muted px-10 py-4 text-sm">
          <span class="text-mui-muted-foreground">Don’t have an account?</span>
          <.button variant="link" class="ml-1 text-mui-brand">Sign up</.button>
        </.card_footer>
      </.card>
    </.example>

    <.props_table
      locale={@locale}
      rows={[
        {"card", "component", "Vuzeno-style outer surface with border, p-1 and rounded-xl"},
        {"card_header", "component", "flex column with gap-1 and p-3"},
        {"card_title", "component", "text-xl font-semibold"},
        {"card_description", "component", "text-sm text-mui-muted-foreground"},
        {"card_content", "component", "inset bordered surface with p-3 and rounded-lg"},
        {"card_footer", "component", "flex row with px-3, pt-1.5 and pb-0.5"}
      ]}
    />
    """
  end

  defp sign_in_code do
    ~S'''
    <.card class="mui-card-elevated w-full max-w-[25rem] overflow-hidden border-mui-card-border bg-mui-card p-0">
      <.card_header class="items-center gap-1 px-10 pt-8 pb-6 text-center">
        <.card_title class="text-base tracking-normal">Sign in to your account</.card_title>
        <.card_description>Welcome back! Please sign in to continue</.card_description>
      </.card_header>

      <.card_content class="grid gap-6 rounded-none border-0 bg-transparent px-10 pt-0 pb-8 mui-dark:bg-transparent">
        <div class="grid grid-cols-2 gap-2">
          <.button variant="outline" class="mui-social-button w-full border-transparent">
            <:icon>
              <.icon name="github-logo" />
            </:icon>
            GitHub
          </.button>
          <.button variant="outline" class="mui-social-button w-full border-transparent">
            <:icon>
              <.icon name="google-logo" />
            </:icon>
            Google
          </.button>
        </div>

        <div class="flex items-center gap-4 text-sm text-mui-muted-foreground">
          <div class="h-px flex-1 bg-mui-card-border" />
          <span>or</span>
          <div class="h-px flex-1 bg-mui-card-border" />
        </div>

        <.form for={to_form(%{}, as: :sign_in)} id="sign-in-form" class="grid gap-5">
          <.field :let={id} id="sign-in-email">
            <.field_label for={id}>Email address</.field_label>
            <.input
              id={id}
              name="email"
              type="email"
              placeholder="Enter your email address"
              autocomplete="email"
            />
          </.field>
          <.button type="submit" variant="brand" class="w-full">
            Continue
            <.icon name="arrow-right" class="size-3" />
          </.button>
        </.form>

        <.button variant="link" class="mx-auto text-mui-brand">Use passkey instead</.button>
      </.card_content>

      <.card_footer class="justify-center border-t border-mui-card-border bg-mui-card-muted px-10 py-4 text-sm">
        <span class="text-mui-muted-foreground">Don’t have an account?</span>
        <.button variant="link" class="ml-1 text-mui-brand">Sign up</.button>
      </.card_footer>
    </.card>
    '''
  end
end
