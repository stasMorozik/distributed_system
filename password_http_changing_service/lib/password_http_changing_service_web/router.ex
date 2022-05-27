defmodule PasswordHttpChangingServiceWeb.Router do
  use PasswordHttpChangingServiceWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PasswordHttpChangingServiceWeb do
    pipe_through :api

    patch "/:id", PasswordController, :update_email
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: PasswordHttpChangingServiceWeb.Telemetry
    end
  end
end
