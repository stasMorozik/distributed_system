defmodule UserHttpRegistratingServiceWeb.Router do
  use UserHttpRegistratingServiceWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", UserHttpRegistratingServiceWeb do
    pipe_through :api

    post "/", RegistratingController, :register
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: UserHttpRegistratingServiceWeb.Telemetry
    end
  end
end
