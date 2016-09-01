![](https://github.com/robot-overlord/algae/blob/master/brand/logo.png?raw=true)

[![Build Status](https://travis-ci.org/expede/algae.svg?branch=master)](https://travis-ci.org/expede/algae) [![Inline docs](http://inch-ci.org/github/expede/algae.svg?branch=master)](http://inch-ci.org/github/expede/algae) [![Deps Status](https://beta.hexfaktor.org/badge/all/github/expede/algae.svg)](https://beta.hexfaktor.org/github/expede/algae) [![hex.pm version](https://img.shields.io/hexpm/v/algae.svg?style=flat)](https://hex.pm/packages/algae) [![API Docs](https://img.shields.io/badge/api-docs-yellow.svg?style=flat)](http://hexdocs.pm/algae/) [![license](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)](https://github.com/expede/algae/blob/master/LICENSE)

# TL;DR
Algae is a collection of common data structures, intended for use with libraries like [Witchcraft](https://hex.pm/packages/witchcraft)

# Quickstart
Add Algae to your list of dependencies in `mix.exs`:

```elixir

def deps do
  [{:algae, "~> 0.12"}]
end

```

# Select Examples

## Maybe

```elixir
import Algae.Maybe

[1,2,3]
|> List.first
|> case do
     nil  -> nothing
     head -> just(head)
   end
#=> %Algae.Maybe.Just{just: 1}

[]
|> List.first
|> case do
     nil  -> nothing
     head -> just(head)
   end
#=> %Algae.Maybe.Nothing{}
```

## Reader

```elixir
%Algae.Reader{env: 42} |> read
# 42

config =
  %Algae.Reader.new{
    reader: &Map.get/1,
    env: %{
      uri:   "https://api.awesomeservice.com",
      token: "12345"
    }
  }
:uri |> read(config)
#=> "https://api.awesomeservice.com"

elapsed_time =
  %Algae.Reader.new{
    env: %{start_time: 1472717375},
    reader:
      fn %{start_time: start_time} ->
        now = DateTime.now |> DateTime.to_unix
        "#{now - start_time}ms"
      end
  }
run elapsed_time
#=> "42ms"
```
