defmodule Algae.Mixfile do
  use Mix.Project

  def project do
    [
      app: :algae,
      aliases: aliases(),
      deps: deps(),

      # Versions
      version: "1.2.4",
      elixir: "~> 1.9",

      # Docs
      name: "Algae",
      docs: docs(),

      # Hex
      description: "Bootstrapped algebraic data types for Elixir",
      package: package()
    ]
  end

  defp aliases do
    [
      quality: ["test", "credo --strict"]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.1", only: [:dev, :test]},
      {:dialyxir, "~> 0.5", only: :dev},
      {:earmark, "~> 1.4.0", only: :dev},
      {:ex_doc, "~> 0.21.2", only: :dev},
      {:inch_ex, "~> 2.0", only: [:dev, :docs, :test]},
      {:quark, "~> 2.3"},
      {:type_class, "~> 1.2"},
      {:witchcraft, "~> 1.0"}
    ]
  end

  defp docs do
    [
      extras: ["README.md"],
      logo: "./brand/mini-logo.png",
      main: "readme",
      source_url: "https://github.com/witchcrafters/algae"
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/witchcrafters/algae"},
      maintainers: ["Brooklyn Zelenka"]
    ]
  end
end
