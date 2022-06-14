defmodule Passwords.Repo do
  use Ecto.Repo,
    otp_app: :user_password_postgres_service,
    adapter: Ecto.Adapters.Postgres
end
