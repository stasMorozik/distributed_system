defmodule HttpUserEntryPointServiceWeb.Router do
  use HttpUserEntryPointServiceWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HttpUserEntryPointServiceWeb do
    pipe_through :api

    post "/confirm", UserController, :confirm
    post "/sign-up", UserController, :sign_up
    post "/sign-in", UserController, :sign_in
    get "/sign-out", UserController, :sign_out
  end


  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: HttpUserEntryPointServiceWeb.Telemetry
    end
  end
end
