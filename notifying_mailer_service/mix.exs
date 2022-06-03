defmodule NotifyingMailerService.MixProject do
  use Mix.Project

  def project do
    [
      app: :notifying_mailer_service,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {NotifyingMailerService.Application, []}
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.3"},
      {:bamboo, "~> 2.2.0"},
      {:bamboo_smtp, "~> 4.1.0"}
    ]
  end
end
