# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configures the endpoint
config :http_buyer_entry_point_service, HttpBuyerEntryPointServiceWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4001],
  debug_errors: false,
  render_errors: [view: HttpBuyerEntryPointServiceWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: HttpBuyerEntryPointService.PubSub,
  live_view: [signing_salt: "AJ0eDnzW"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
