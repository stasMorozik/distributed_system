import Config

config :user_password_postgres_service, Passwords.Repo,
  database: "user_password_postgres_service_repo",
  username: "user",
  password: "pass",
  hostname: "localhost"

config :user_password_postgres_service, Passwords.Repo,
  database: "passwords",
  username: "me3",
  password: "123",
  hostname: "localhost"

config :user_password_postgres_service, ecto_repos: [Passwords.Repo]
