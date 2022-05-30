import Config

config :user_postgres_service, Persons.Repo,
  database: "persons",
  username: "me3",
  password: "123",
  hostname: "localhost"
