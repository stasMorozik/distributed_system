# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Sample configuration:
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]
#

config :task_adapters_for_user_service, :service_users,
  remote_node: :service_users@localhost,
  remote_supervisor: {Controller, :service_users@localhost},
  remote_module: Controller

config :task_adapters_for_buyer_service, :service_buyers,
  remote_node: :service_buyers@localhost,
  remote_supervisor: {Controller, :service_buyers@localhost},
  remote_module: Controller

config :task_adapters_for_confirming_email_service, :service_confirming_email,
  remote_node: :service_confirming_email@localhost,
  remote_supervisor: {Controller, :service_confirming_email@localhost},
  remote_module: Controller

config :task_adapters_for_notifying_service, :service_notifying,
  remote_node: :service_notifying@localhost,
  remote_supervisor: {Controller, :service_notifying@localhost},
  remote_module: Controller

config :task_adapters_for_shop_service, :service_shop,
  remote_node: :service_shop@localhost,
  remote_supervisor: {Controller, :service_shop@localhost},
  remote_module: Controller

config :task_adapters_for_user_jwt_service, :service_jwt,
  remote_node: :service_jwt@localhost,
  remote_supervisor: {Controller, :service_jwt@localhost},
  remote_module: Controller,
  secret_key: "dhriklbnciesc84uiv71",
  secret_ex_key: "ap098hvb3w3dh8mvg754"

config :task_adapters_for_buyer_jwt_service, :service_jwt,
  remote_node: :service_jwt@localhost,
  remote_supervisor: {Controller, :service_jwt@localhost},
  remote_module: Controller,
  secret_key: "ujb136ndaiewc84fiv71",
  secret_ex_key: "xv6h7ge4vj2fn45bwc1p"

config :http_user_entry_point_service, HttpUserEntryPointServiceWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  debug_errors: false,
  render_errors: [view: HttpUserEntryPointServiceWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: HttpUserEntryPointService.PubSub,
  live_view: [signing_salt: "wOWltuIV"]

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
