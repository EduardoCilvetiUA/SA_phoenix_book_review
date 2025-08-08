defmodule PhoenixBookReviewWeb.Router do
  use PhoenixBookReviewWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PhoenixBookReviewWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhoenixBookReviewWeb do
    pipe_through :browser

    get "/", PageController, :home
    
    resources "/authors", AuthorController
    resources "/books", BookController
    resources "/reviews", ReviewController
    resources "/sales", SalesController
    
    get "/analytics", AnalyticsController, :index
    get "/analytics/authors_stats", AnalyticsController, :authors_stats
    get "/analytics/top_rated_books", AnalyticsController, :top_rated_books
    get "/analytics/top_selling_books", AnalyticsController, :top_selling_books
    get "/analytics/search", AnalyticsController, :search_books
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhoenixBookReviewWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:phoenix_book_review, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PhoenixBookReviewWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
