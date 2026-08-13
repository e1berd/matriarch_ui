defmodule MatriarchUIDocsWeb.Docs.ComponentLive do
  use MatriarchUIDocsWeb, :live_view
  alias MatriarchUIDocsWeb.{DocsSidebar, Registry}

  def mount(%{"slug" => slug}, _session, socket) do
    case Registry.fetch(slug) do
      nil -> {:ok, push_navigate(socket, to: ~p"/docs")}
      entry -> {:ok, assign(socket, page_title: entry.title, entry: entry)}
    end
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="mx-auto flex max-w-6xl gap-2 px-6">
        <DocsSidebar.sidebar active={@entry.slug} />
        <div class="min-w-0 flex-1 border-l border-mui-border py-10 pl-8">
          <h1 class="text-2xl font-semibold text-mui-foreground">{@entry.title}</h1>
          <div class="mt-8 flex flex-col gap-10">
            {apply(@entry.module, :examples, [%{}])}
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
