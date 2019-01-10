defmodule ConferencesParser.MixProject do
  use Mix.Project

  def project do
    [
      app: :conferences_parser,
      version: "0.1.0",
      elixir: "~> 1.8-dev",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.0"},
      {:poison, "~> 3.1"},
      {:flow, "~> 0.14"},
      {:floki, "~> 0.20.0"},
      {:nimble_csv, "~> 0.3"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
