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

config :adapters, :user_postgres_service,
  remote_supervisor: {Persons.Repo.TaskSupervisor, :user_postgres_service@localhost},
  remote_node: :user_postgres_service@localhost,
  remote_module: UserPostgresService

config :adapters, :user_password_postgres_service,
  remote_supervisor: {UserPasswordPostgresService.TaskSupervisor, :user_password_postgres_service@localhost},
  remote_node: :user_password_postgres_service@localhost,
  remote_module: UserPasswordPostgresService

config :adapters, :notifying_mailer_service,
  remote_supervisor: {NotifyingMailerService.TaskSupervisor, :notifying_mailer_service@localhost},
  remote_node: :notifying_mailer_service@localhost,
  remote_module: NotifyingMailerService

config :core, :user_logger_service,
  remote_supervisor: {UserLoggerService.TaskSupervisor, :user_logger_service@localhost},
  remote_node: :user_logger_service@localhost,
  remote_module: UserLoggerService

config :joken, user_signer: "user_secret"
