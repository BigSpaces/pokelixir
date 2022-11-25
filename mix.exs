defmodule Pokelixir.MixProject do
  use Mix.Project

  def project do
    [
      app: :pokelixir,
      name: "Pokelixir",
      source_url: "https://github.com/BigSpaces/pokelixir",
      homepage_url: "https://github.com/BigSpaces/pokelixir",
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Pokelixir.Application, "Starting Pokelixir Application"}
    ]
  end

  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:httpoison, "~> 1.8"},
      {:poison, "~> 5.0"}
    ]

  end
end
