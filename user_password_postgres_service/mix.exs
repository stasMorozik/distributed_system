defmodule UserPasswordPostgresService.MixProject do
  use Mix.Project

  def project do
    [
      app: :user_password_postgres_service,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {UserPasswordPostgresService.Application, []}
    ]
  end

  defp deps do
    [
      { :uuid, "~> 1.1" },
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"}
    ]
  end
end
