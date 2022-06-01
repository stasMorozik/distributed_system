# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configures the endpoint
config :user_http_registration_service, UserHttpRegistrationServiceWeb.Endpoint,
  url: [host: "localhost"],
  debug_errors: false,
  render_errors: [view: UserHttpRegistrationServiceWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: UserHttpRegistrationService.PubSub,
  live_view: [signing_salt: "IDw861vE"],
  remote_password_controller_node: :password_controller@localhost,
  remote_user_controller_node: :user_controller@localhost,
  remote_password_controller_super: {PasswordController.TaskSupervisor, :password_controller@localhost},
  remote_user_controller_super: {UserController.TaskSupervisor, :user_controller@localhost},
  remote_password_controller_module: PasswordController,
  remote_user_controller_module: UserController

config :user_http_registration_service,
  remote_password_controller_node: :password_controller@localhost,
  remote_user_controller_node: :user_controller@localhost,
  remote_password_controller_super: {PasswordController.TaskSupervisor, :password_controller@localhost},
  remote_user_controller_super: {UserController.TaskSupervisor, :user_controller@localhost},
  remote_password_controller_module: PasswordController,
  remote_user_controller_module: UserController

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason



# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
