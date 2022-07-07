import Config

config :postgres_adapters, Buyers.Repo,
  database: "buyers",
  username: "me3",
  password: "123",
  hostname: "localhost"

config :postgres_adapters, ecto_repos: [Buyers.Repo]
