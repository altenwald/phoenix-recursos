defmodule VemoslaWeb.Router do
  use VemoslaWeb, :router

  import VemoslaWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {VemoslaWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug VemoslaWeb.Locale
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  if Mix.env() == :dev do
    # If using Phoenix
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  scope "/", VemoslaWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/about", PageController, :index

    get "/terminos-de-servicio", LegalController, :terminos_de_servicio
    get "/terms-of-service", LegalController, :terms_of_service

    get "/features", FeatureController, :index
    get "/features/:id/up", FeatureController, :up
    get "/features/:id/down", FeatureController, :down
  end

  # Other scopes may use custom stacks.
  # scope "/api", VemoslaWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: VemoslaWeb.Telemetry
    end
  end

  ## Authentication routes

  scope "/", VemoslaWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", VemoslaWeb do
    pipe_through [:browser, :require_authenticated_user]

    resources "/posts", PostController, only: [:new, :create, :delete]
    get "/timeline", PostController, :timeline

    get "/users/profile", ProfileController, :show
    get "/users/profile/edit", ProfileController, :edit
    get "/users/:id/profile", ProfileController, :show
    put "/users/profile", ProfileController, :update
    patch "/users/profile", ProfileController, :update

    get "/users/invite", ContactsController, :new
    get "/users/invite/:id", ContactsController, :new
    post "/users/invite", ContactsController, :create
    get "/users/invite/:id/accept", ContactsController, :accept
    get "/users/invite/:id/block", ContactsController, :block
    get "/users/contacts", ContactsController, :index

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email

    resources "/features", FeatureController, only: ~w[ new create edit update delete ]a
  end

  scope "/", VemoslaWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end
end
