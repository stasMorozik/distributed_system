defmodule PasswordPostgresService.MixProject do
  use Mix.Project

  def project do
    [
      app: :password_postgres_service,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {PasswordPostgresService.Application, []}
    ]
  end

  defp deps do
    [
      { :uuid, "~> 1.1" },
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
