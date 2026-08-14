defmodule MatriarchUIDocsWeb.Router do
  use MatriarchUIDocsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {MatriarchUIDocsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", MatriarchUIDocsWeb do
    pipe_through :browser

    live_session :default do
      live "/", LandingLive, :index
      live "/docs", Docs.OverviewLive, :index
      live "/docs/components/chat", Docs.ChatLive, :show
      live "/docs/components/:slug", Docs.ComponentLive, :show
    end
  end
end
