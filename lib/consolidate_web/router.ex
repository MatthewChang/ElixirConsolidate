defmodule ConsolidateWeb.Router do
  use ConsolidateWeb, :router

  pipeline :auth do
    plug Consolidate.Accounts.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ConsolidateWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    get "/login", SessionController, :new
    post "/login", SessionController, :login
    post "/logout", SessionController, :logout
  end


# Definitely logged in scope
  scope "/", ConsolidateWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    get "/cards", CardsController, :index
    get "/cards/new", CardsController, :new
    post "/cards", CardsController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", ConsolidateWeb do
  #   pipe_through :api
  # end
end
