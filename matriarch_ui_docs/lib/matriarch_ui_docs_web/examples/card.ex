defmodule MatriarchUIDocsWeb.Examples.Card do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
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
                <svg class="size-3.5" viewBox="0 0 24 24" fill="none" aria-hidden="true">
                  <circle cx="12" cy="12" r="9" stroke="currentColor" stroke-width="1.5" />
                  <path d="M12 7v5l3 2" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" />
                </svg>
                Last deployment
              </span>
              <span>2 min ago</span>
            </div>
            <div class="flex items-center justify-between">
              <span class="flex items-center gap-2 text-mui-muted-foreground">
                <svg class="size-3.5" viewBox="0 0 24 24" fill="none" aria-hidden="true">
                  <circle cx="6" cy="5" r="2" stroke="currentColor" stroke-width="1.5" />
                  <circle cx="6" cy="19" r="2" stroke="currentColor" stroke-width="1.5" />
                  <circle cx="18" cy="7" r="2" stroke="currentColor" stroke-width="1.5" />
                  <path d="M6 7v10M8 7h4a6 6 0 0 1 6 6v-4" stroke="currentColor" stroke-width="1.5" />
                </svg>
                Branch
              </span>
              <span>main</span>
            </div>
            <div class="flex items-center justify-between">
              <span class="flex items-center gap-2 text-mui-muted-foreground">
                <svg class="size-3.5" viewBox="0 0 24 24" fill="none" aria-hidden="true">
                  <circle cx="12" cy="13" r="8" stroke="currentColor" stroke-width="1.5" />
                  <path
                    d="M9 2h6M12 5v2M12 13l3-2"
                    stroke="currentColor"
                    stroke-width="1.5"
                    stroke-linecap="round"
                  />
                </svg>
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
              <svg class="size-3.5" viewBox="0 0 24 24" fill="none" aria-hidden="true">
                <circle cx="12" cy="12" r="9" stroke="currentColor" stroke-width="1.5" />
                <path d="M12 7v5l3 2" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" />
              </svg>
              Last deployment
            </span>
            <span>2 min ago</span>
          </div>
          <div class="flex items-center justify-between">
            <span class="flex items-center gap-2 text-mui-muted-foreground">
              <svg class="size-3.5" viewBox="0 0 24 24" fill="none" aria-hidden="true">
                <circle cx="6" cy="5" r="2" stroke="currentColor" stroke-width="1.5" />
                <circle cx="6" cy="19" r="2" stroke="currentColor" stroke-width="1.5" />
                <circle cx="18" cy="7" r="2" stroke="currentColor" stroke-width="1.5" />
                <path d="M6 7v10M8 7h4a6 6 0 0 1 6 6v-4" stroke="currentColor" stroke-width="1.5" />
              </svg>
              Branch
            </span>
            <span>main</span>
          </div>
          <div class="flex items-center justify-between">
            <span class="flex items-center gap-2 text-mui-muted-foreground">
              <svg class="size-3.5" viewBox="0 0 24 24" fill="none" aria-hidden="true">
                <circle cx="12" cy="13" r="8" stroke="currentColor" stroke-width="1.5" />
                <path
                  d="M9 2h6M12 5v2M12 13l3-2"
                  stroke="currentColor"
                  stroke-width="1.5"
                  stroke-linecap="round"
                />
              </svg>
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
    </.example>

    <.example
      title="Clerk sign in"
      description="The Clerk dashboard sign-in layout composed from the same Card, Button, Field and Input primitives."
      code={clerk_sign_in_code()}
    >
      <.card class="mui-card-elevated w-full max-w-[25rem] overflow-hidden border-mui-card-border bg-mui-card p-0">
        <.card_header class="items-center gap-1 px-10 pt-8 pb-6 text-center">
          <div class="mb-2 flex items-center gap-1.5 text-mui-foreground" aria-label="Clerk">
            <svg class="size-5" viewBox="0 0 20 20" fill="none" aria-hidden="true">
              <circle cx="10" cy="10" r="3.1" fill="currentColor" />
              <path
                d="M15.6 3.2A8 8 0 0 0 2 10c0 1.7.5 3.3 1.4 4.6l3.1-3.1A4.1 4.1 0 0 1 10 5.9c.8 0 1.5.2 2.1.6l3.5-3.3Z"
                fill="currentColor"
                opacity=".45"
              />
              <path
                d="M15.8 16.6a8 8 0 0 1-9.9.3l3.2-3.2a4.1 4.1 0 0 0 3.6-.3l3.1 3.2Z"
                fill="currentColor"
              />
            </svg>
            <span class="text-xl font-bold tracking-tight">clerk</span>
          </div>
          <.card_title class="text-base tracking-normal">Sign in to Clerk</.card_title>
          <.card_description>Welcome back! Please sign in to continue</.card_description>
        </.card_header>

        <.card_content class="grid gap-6 rounded-none border-0 bg-transparent px-10 pt-0 pb-8 mui-dark:bg-transparent">
          <div class="grid grid-cols-2 gap-2">
            <.button variant="outline" class="mui-social-button w-full border-transparent">
              <:icon>
                <svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
                  <path d="M12 2a10 10 0 0 0-3.16 19.49c.5.09.68-.22.68-.48v-1.87c-2.78.6-3.37-1.18-3.37-1.18-.45-1.16-1.11-1.47-1.11-1.47-.91-.62.07-.61.07-.61 1 .07 1.53 1.03 1.53 1.03.9 1.53 2.35 1.09 2.92.83.09-.65.35-1.09.64-1.34-2.22-.25-4.55-1.11-4.55-4.94 0-1.09.39-1.98 1.03-2.68-.1-.25-.45-1.27.1-2.64 0 0 .84-.27 2.75 1.02A9.55 9.55 0 0 1 12 6.82a9.5 9.5 0 0 1 2.5.34c1.91-1.29 2.75-1.02 2.75-1.02.55 1.37.2 2.39.1 2.64.64.7 1.03 1.59 1.03 2.68 0 3.84-2.34 4.68-4.56 4.93.36.31.68.92.68 1.86v2.76c0 .27.18.58.69.48A10 10 0 0 0 12 2Z" />
                </svg>
              </:icon>
              GitHub
            </.button>
            <.button variant="outline" class="mui-social-button w-full border-transparent">
              <:icon>
                <svg viewBox="0 0 24 24" fill="none" aria-hidden="true">
                  <path
                    d="M20 12.2c0-.7-.06-1.2-.18-1.75H12v3.1h4.59a3.9 3.9 0 0 1-1.7 2.55v2.17h2.76C19.27 16.78 20 14.57 20 12.2Z"
                    fill="currentColor"
                  />
                  <path
                    d="M12 20c2.3 0 4.23-.76 5.65-2.06l-2.76-2.17c-.77.52-1.75.88-2.89.88-2.22 0-4.1-1.5-4.78-3.52H4.37v2.24A8 8 0 0 0 12 20Z"
                    fill="currentColor"
                    opacity=".8"
                  />
                  <path
                    d="M7.22 13.13A4.8 4.8 0 0 1 7 11.7c0-.5.08-.98.22-1.43V8.03H4.37A8 8 0 0 0 4 11.7c0 1.29.31 2.5.87 3.67l2.35-2.24Z"
                    fill="currentColor"
                    opacity=".6"
                  />
                  <path
                    d="M12 6.75c1.25 0 2.37.43 3.25 1.27l2.46-2.45A8.2 8.2 0 0 0 12 3.4a8 8 0 0 0-7.63 4.63l2.85 2.24A5.08 5.08 0 0 1 12 6.75Z"
                    fill="currentColor"
                    opacity=".4"
                  />
                </svg>
              </:icon>
              Google
            </.button>
          </div>

          <div class="flex items-center gap-4 text-sm text-mui-muted-foreground">
            <div class="h-px flex-1 bg-mui-card-border" />
            <span>or</span>
            <div class="h-px flex-1 bg-mui-card-border" />
          </div>

          <.form for={to_form(%{}, as: :sign_in)} id="clerk-sign-in-form" class="grid gap-5">
            <.field :let={id} id="clerk-email">
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
              <svg class="size-3" viewBox="0 0 12 12" fill="none" aria-hidden="true">
                <path
                  d="m4.5 3 3 3-3 3"
                  stroke="currentColor"
                  stroke-width="1.5"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                />
              </svg>
            </.button>
          </.form>

          <.button variant="link" class="mx-auto text-mui-brand">Use passkey instead</.button>
        </.card_content>

        <.card_footer class="justify-center border-t border-mui-card-border bg-mui-card-muted px-10 py-4 text-sm">
          <span class="text-mui-muted-foreground">Don’t have an account?</span>
          <.button variant="link" class="ml-1 text-mui-brand">Sign up</.button>
        </.card_footer>
        <.card_footer class="justify-center border-t border-mui-card-border bg-mui-card-muted px-10 py-4 text-xs text-mui-muted-foreground">
          Secured by&nbsp;<span class="font-semibold">clerk</span>
        </.card_footer>
      </.card>
    </.example>

    <.props_table rows={[
      {"card", "component", "Vuzeno-style outer surface with border, p-1 and rounded-xl"},
      {"card_header", "component", "flex column with gap-1 and p-3"},
      {"card_title", "component", "text-xl font-semibold"},
      {"card_description", "component", "text-sm text-mui-muted-foreground"},
      {"card_content", "component", "inset bordered surface with p-3 and rounded-lg"},
      {"card_footer", "component", "flex row with px-3, pt-1.5 and pb-0.5"}
    ]} />
    """
  end

  defp clerk_sign_in_code do
    ~S'''
    <.card class="mui-card-elevated w-full max-w-[25rem] overflow-hidden border-mui-card-border bg-mui-card p-0">
      <.card_header class="items-center gap-1 px-10 pt-8 pb-6 text-center">
        <div class="mb-2 flex items-center gap-1.5 text-mui-foreground" aria-label="Clerk">
          <svg class="size-5" viewBox="0 0 20 20" fill="none" aria-hidden="true">
            <circle cx="10" cy="10" r="3.1" fill="currentColor" />
            <path
              d="M15.6 3.2A8 8 0 0 0 2 10c0 1.7.5 3.3 1.4 4.6l3.1-3.1A4.1 4.1 0 0 1 10 5.9c.8 0 1.5.2 2.1.6l3.5-3.3Z"
              fill="currentColor"
              opacity=".45"
            />
            <path
              d="M15.8 16.6a8 8 0 0 1-9.9.3l3.2-3.2a4.1 4.1 0 0 0 3.6-.3l3.1 3.2Z"
              fill="currentColor"
            />
          </svg>
          <span class="text-xl font-bold tracking-tight">clerk</span>
        </div>
        <.card_title class="text-base tracking-normal">Sign in to Clerk</.card_title>
        <.card_description>Welcome back! Please sign in to continue</.card_description>
      </.card_header>

      <.card_content class="grid gap-6 rounded-none border-0 bg-transparent px-10 pt-0 pb-8 mui-dark:bg-transparent">
        <div class="grid grid-cols-2 gap-2">
          <.button variant="outline" class="mui-social-button w-full border-transparent">
            <:icon>
              <svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
                <path d="M12 2a10 10 0 0 0-3.16 19.49c.5.09.68-.22.68-.48v-1.87c-2.78.6-3.37-1.18-3.37-1.18-.45-1.16-1.11-1.47-1.11-1.47-.91-.62.07-.61.07-.61 1 .07 1.53 1.03 1.53 1.03.9 1.53 2.35 1.09 2.92.83.09-.65.35-1.09.64-1.34-2.22-.25-4.55-1.11-4.55-4.94 0-1.09.39-1.98 1.03-2.68-.1-.25-.45-1.27.1-2.64 0 0 .84-.27 2.75 1.02A9.55 9.55 0 0 1 12 6.82a9.5 9.5 0 0 1 2.5.34c1.91-1.29 2.75-1.02 2.75-1.02.55 1.37.2 2.39.1 2.64.64.7 1.03 1.59 1.03 2.68 0 3.84-2.34 4.68-4.56 4.93.36.31.68.92.68 1.86v2.76c0 .27.18.58.69.48A10 10 0 0 0 12 2Z" />
              </svg>
            </:icon>
            GitHub
          </.button>
          <.button variant="outline" class="mui-social-button w-full border-transparent">
            <:icon>
              <svg viewBox="0 0 24 24" fill="none" aria-hidden="true">
                <path
                  d="M20 12.2c0-.7-.06-1.2-.18-1.75H12v3.1h4.59a3.9 3.9 0 0 1-1.7 2.55v2.17h2.76C19.27 16.78 20 14.57 20 12.2Z"
                  fill="currentColor"
                />
                <path
                  d="M12 20c2.3 0 4.23-.76 5.65-2.06l-2.76-2.17c-.77.52-1.75.88-2.89.88-2.22 0-4.1-1.5-4.78-3.52H4.37v2.24A8 8 0 0 0 12 20Z"
                  fill="currentColor"
                  opacity=".8"
                />
                <path
                  d="M7.22 13.13A4.8 4.8 0 0 1 7 11.7c0-.5.08-.98.22-1.43V8.03H4.37A8 8 0 0 0 4 11.7c0 1.29.31 2.5.87 3.67l2.35-2.24Z"
                  fill="currentColor"
                  opacity=".6"
                />
                <path
                  d="M12 6.75c1.25 0 2.37.43 3.25 1.27l2.46-2.45A8.2 8.2 0 0 0 12 3.4a8 8 0 0 0-7.63 4.63l2.85 2.24A5.08 5.08 0 0 1 12 6.75Z"
                  fill="currentColor"
                  opacity=".4"
                />
              </svg>
            </:icon>
            Google
          </.button>
        </div>

        <div class="flex items-center gap-4 text-sm text-mui-muted-foreground">
          <div class="h-px flex-1 bg-mui-card-border" />
          <span>or</span>
          <div class="h-px flex-1 bg-mui-card-border" />
        </div>

        <.form for={to_form(%{}, as: :sign_in)} id="clerk-sign-in-form" class="grid gap-5">
          <.field :let={id} id="clerk-email">
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
            <svg class="size-3" viewBox="0 0 12 12" fill="none" aria-hidden="true">
              <path
                d="m4.5 3 3 3-3 3"
                stroke="currentColor"
                stroke-width="1.5"
                stroke-linecap="round"
                stroke-linejoin="round"
              />
            </svg>
          </.button>
        </.form>

        <.button variant="link" class="mx-auto text-mui-brand">Use passkey instead</.button>
      </.card_content>

      <.card_footer class="justify-center border-t border-mui-card-border bg-mui-card-muted px-10 py-4 text-sm">
        <span class="text-mui-muted-foreground">Don’t have an account?</span>
        <.button variant="link" class="ml-1 text-mui-brand">Sign up</.button>
      </.card_footer>
      <.card_footer class="justify-center border-t border-mui-card-border bg-mui-card-muted px-10 py-4 text-xs text-mui-muted-foreground">
        Secured by&nbsp;<span class="font-semibold">clerk</span>
      </.card_footer>
    </.card>
    '''
  end
end
