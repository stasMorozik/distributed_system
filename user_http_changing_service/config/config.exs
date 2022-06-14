# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configures the endpoint
config :user_http_changing_service, UserHttpChangingServiceWeb.Endpoint,
  url: [host: "localhost"],
  debug_errors: false,
  render_errors: [view: UserHttpChangingServiceWeb.ErrorView, accepts: ~w(json)],
  pubsub_server: UserHttpChangingService.PubSub,
  live_view: [signing_salt: "LTcf6gR4"]

config :user_http_changing_service, :user_controller,
  remote_node: :user_controller@localhost,
  remote_supervisor: {UserController.TaskSupervisor, :user_controller@localhost},
  remote_module: UserController

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
