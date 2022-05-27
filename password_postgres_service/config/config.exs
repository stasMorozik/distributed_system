import Config

config :password_postgres_service, Passwords.Repo,
  database: "passwords",
  username: "me3",
  password: "123",
  hostname: "localhost"

config :password_postgres_service, ecto_repos: [Passwords.Repo]
