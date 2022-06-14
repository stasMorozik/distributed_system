use Mix.Config

config :user_password_postgres_service, Passwords.Repo,
  database: "passwords",
  username: "me3",
  password: "123",
  hostname: "localhost"

config :user_password_postgres_service, ecto_repos: [Passwords.Repo]
