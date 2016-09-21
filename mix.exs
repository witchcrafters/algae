defmodule Algae.Mixfile do
  use Mix.Project

  def project do
    [app:     :algae,
     name:    "Algae",

     description: "Bootstrapped algebraic data types for Elixir",
     version: "0.12.0",
     elixir:  "~> 1.3",

     package: [
       maintainers: ["Brooklyn Zelenka"],
       licenses:    ["MIT"],
       links:       %{"GitHub" => "https://github.com/expede/algae"}
     ],

     source_url:   "https://github.com/expede/algae",
     homepage_url: "https://github.com/expede/algae",

     aliases: ["quality": ["test", "credo --strict"]],

     deps: [
       {:credo,    "~> 0.4",  only: [:dev, :test]},

       {:dialyxir, "~> 0.3",  only: :dev},
       {:earmark,  "~> 1.0",  only: :dev},
       {:ex_doc,   "~> 0.13", only: :dev},

       {:inch_ex,  "~> 0.5",  only: [:dev, :docs, :test]},
       {:algae,    "~> 2.1"}
     ],

     docs: [
       extras: ["README.md"],
       logo: "./brand/logo.png",
       main: "readme"
     ]
    ]
  end
end
