defmodule Algae.Mixfile do
  use Mix.Project

  def project do
    [app:     :algae,
     name:    "Algae",

     description: "Bootstrapped algebraic data types for Elixir",
     package: package,

     version: "0.5.1",
     elixir:  "~> 1.1",

     source_url:   "https://github.com/robot-overlord/algae",
     homepage_url: "https://github.com/robot-overlord/algae",

     build_embedded:  Mix.env == :prod,
     start_permanent: Mix.env == :prod,

     deps: deps,
     docs: [logo: "https://github.com/robot-overlord/algae/blob/master/logo.png?raw=true",
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
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.10", only: :dev},
      {:quark, "~> 1.0.0"},
      {:witchcraft, "~> 0.2.0"}
    ]
  end

  defp package do
    [maintainers: ["Brooklyn Zelenka", "Jennifer Cooper"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/robot-overlord/witchcraft",
              "Docs" => "http://robot-overlord.github.io/witchcraft/"}]
  end
end
