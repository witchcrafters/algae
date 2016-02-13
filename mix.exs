defmodule Algae.Mixfile do
  use Mix.Project

  def project do
    [app:     :algae,
     name:    "Algae",

     description: "Bootstrapped algebraic data types for Elixir",
     package: package,

     version: "0.8.0",
     elixir:  "~> 1.2",

     source_url:   "https://github.com/robot-overlord/algae",
     homepage_url: "https://github.com/robot-overlord/algae",

     build_embedded:  Mix.env == :prod,
     start_permanent: Mix.env == :prod,

     deps: deps,
     docs: [logo: "./logo.png",
            extras: ["README.md"]]]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
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
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:earmark, "~> 0.2", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev},
      {:inch_ex, "~> 0.5", only: :docs},
      {:quark, "~> 1.0"}
    ]
  end

  defp package do
    [maintainers: ["Brooklyn Zelenka"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/robot-overlord/algae",
              "Docs" => "http://robot-overlord.github.io/algae/"}]
  end
end
