# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configures the endpoint
config :password_http_changing_service, PasswordHttpChangingServiceWeb.Endpoint,
  url: [host: "localhost"],
  debug_errors: false,
  render_errors: [view: PasswordHttpChangingServiceWeb.ErrorView, accepts: ~w(json)],
  pubsub_server: PasswordHttpChangingService.PubSub,
  live_view: [signing_salt: "Z4AO24qc"]

config :password_http_changing_service, :password_controller,
  remote_node: :password_controller@dev,
  remote_supervisor: {PasswordController.TaskSupervisor, :password_controller@dev},
  remote_module: PasswordController

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
