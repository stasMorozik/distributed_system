defmodule HttpBuyerEntryPointServiceWeb.Router do
  use HttpBuyerEntryPointServiceWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HttpBuyerEntryPointServiceWeb do
    pipe_through :api

    post "/confirm-email", BuyerController, :confirm_email
    post "/sign-up", BuyerController, :sign_up
    post "/sign-in", BuyerController, :sign_in
    get "/sign-out", BuyerController, :sign_out
    get "/refresh-token", BuyerController, :refresh_token
    get "/get", BuyerController, :get
    put "/update-email", BuyerController, :update_email
    put "/update", BuyerController, :update
  end

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
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: HttpBuyerEntryPointServiceWeb.Telemetry
    end
  end
end
