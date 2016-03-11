defmodule Technicalanalysis.Mixfile do
  use Mix.Project

  def project do
    [app: :technicalanalysis,
     version: "0.0.1",
     elixir: "~> 1.0",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: [main_module: Technicalanalysis.Program],
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:timex, "~> 0.16.0"},
      {:mongo, "~> 0.5.1"},
      {:stockanalyzer_mongo, in_umbrella: true}
    ]
  end
end
