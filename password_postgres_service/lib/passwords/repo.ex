defmodule Passwords.Repo do
  use Ecto.Repo,
    otp_app: :password_postgres_service,
    adapter: Ecto.Adapters.Postgres
end
