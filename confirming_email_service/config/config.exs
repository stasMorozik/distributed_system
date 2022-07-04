import Config

config :postgres_adapters, Codes.Repo,
  database: "codes",
  username: "me3",
  password: "123",
  hostname: "localhost"

config :postgres_adapters, ecto_repos: [Codes.Repo]
