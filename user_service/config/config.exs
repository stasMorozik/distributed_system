
import Config

config :postgres_adapters, Users.Repo,
  database: "users",
  username: "me3",
  password: "123",
  hostname: "localhost"


config :postgres_adapters, ecto_repos: [Users.Repo]
