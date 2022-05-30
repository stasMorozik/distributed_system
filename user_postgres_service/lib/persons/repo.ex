defmodule Persons.Repo do
  use Ecto.Repo,
    otp_app: :user_postgres_service,
    adapter: Ecto.Adapters.Postgres
end
