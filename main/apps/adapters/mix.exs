defmodule Adapters.MixProject do
  use Mix.Project

  def project do
    [
      app: :adapters,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Adapters.Application, []}
    ]
  end

  defp deps do
    [
      { :uuid, "~> 1.1" },
      {:core, in_umbrella: true}
    ]
  end
end
