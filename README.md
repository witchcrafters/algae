![](https://github.com/robot-overlord/algae/blob/main/brand/logo.png?raw=true)

[![Build Status](https://travis-ci.org/expede/algae.svg?branch=master)](https://travis-ci.org/expede/algae) [![Inline docs](http://inch-ci.org/github/expede/algae.svg?branch=master)](http://inch-ci.org/github/expede/algae) [![Deps Status](https://beta.hexfaktor.org/badge/all/github/expede/algae.svg)](https://beta.hexfaktor.org/github/expede/algae) [![hex.pm version](https://img.shields.io/hexpm/v/algae.svg?style=flat)](https://hex.pm/packages/algae) [![API Docs](https://img.shields.io/badge/api-docs-yellow.svg?style=flat)](http://hexdocs.pm/algae/) [![license](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)](https://github.com/expede/algae/blob/master/LICENSE)

Algae provides a boilerplate-avoiding DSL for defining algebraic data types (ADTs),
plus several common structures

# Quickstart
Add Algae to your list of dependencies in `mix.exs`:

```elixir

def deps do
  [{:algae, "~> 1.2"}]
end

```

# Table of Contents

- [Product Builder](#product-builder)
  - [Definition DSL](#definition-dsl)
  - [Constructor](#constructor)
  - [Empty Tag](#empty-tag)
- [Sum Builder](#sum-builder)
  - [Default Constructor](#default-constructor)
  - [Tagged Unions](#tagged-unions)
- [A Sampling of ADTs](#a-sampling-of-adts)
  - [`Id`](#algaeid)
  - [`Maybe`](#algaemaybe)
  - [`Tree.BinarySearch`](#algaetreebinarysearch)

---

> **NOTE**  
> Please `import Algae` before trying out the examples below.
> The samples assume that is has already been done to remove
> the unnecessary clutter.

---

# Product Builder
Build a product type

Includes:

* Struct
* Type definition
* Constructor function (for piping and defaults)
* Implicit defaults for simple values

## Definition DSL

For convenience, several variants of the DSL are available.

### Standard

```elixir
defmodule Player do
  # =============== #
  # Data Definition #
  # =============== #

  defdata do
    name       :: String.t()
    hit_points :: non_neg_integer()
    experience :: non_neg_integer()
  end

  # =================== #
  #    Rest of Module   #
  # (business as usual) #
  # =================== #

  @spec attack(t(), t()) :: {t(), t()}
  def attack(%{experience: xp} = player, %{hit_points: hp} = target) do
    {
      %{player | experience: xp + 50},
      %{target | hit_points: hp - 10}
    }
  end
end

#=> %Player{name: "Sir Bob", hit_points: 10, experience: 500}
```

### Single Field Shorthand

Without any fields specified, Algae will default to a single field with
the same name as the module (essentially a "wrapper type"). You must still
provide the type for this field, however.

Embedded in another module:

```elixir
defmodule Id do
  defdata any()
end

%Id{}
#=> %Id{id: nil}
```

Standalone:

```elixir
defdata Wrapper :: any()

%Wrapper{}
#=> %Wrapper{wrapper: nil}
```

## Constructor

A helper function, especially useful for piping. The order of arguments is
the same as the order that they are defined in.

```elixir
defmodule Person do
  defdata do
    name :: String.t()
    age  :: non_neg_integer()
  end
end

Person.new("Rachel Weintraub")
#=> %Person{
#     name: "Rachel Weintraub",
#     age:  0
#   }
```

### Constructor Defaults

Fields will automatically default to a sensible value (a typical "zero" for
that datatype). For example, `non_neg_integer()` will default to `0`,
and `String.t()` will default to `""`.

You may also overwrite these defaults with the `\\` syntax.

```elixir
defmodule Pet do
  defdata do
    name      :: String.t()
    leg_count :: non_neg_integer() \\ 4
  end
end

Pet.new("Crookshanks")
#=> %Pet{
#     name: "Crookshanks",
#     leg_count: 4
#   }

Pet.new("Paul the Psychic Octopus", 8)
#=> %Pet{
#     name: "Paul the Psychic Octopus",
#     leg_count: 8
#   }
```

This overwriting syntax is _required_ for complex types:

```elixir
defdata Grocery do
  item :: {String.t(), integer(), boolean()} \\ {"Orange", 4, false}
end

Grocery.new()
#=> %Grocery{
#     item: {"Orange", 4, false}
#   }
```

### Overwrite Constructor

The `new` constructor function may be overwritten.

```elixir
defmodule Constant do
  defdata :: fun()

  def new(value), do: %Constant{constant: fn _ -> value end}
end

fourty_two = Constant.new(42)
fourty_two.constant.(33)
#=> 42
```

## Empty Tag

An empty type (with no fields) is definable using the `none`() type

```elixir
defmodule Nothing do
  defdata none()
end

Nothing.new()
#=> %Nothing{}
```

# Sum Builder

Build a sum (coproduct) type from product types

```elixir
defmodule Light do
  # ============== #
  # Sum Definition #
  # ============== #

  defsum do
    defdata Red    :: none()
    defdata Yellow :: none()
    defdata Green  :: none()
  end

  # =================== #
  #    Rest of Module   #
  # (business as usual) #
  # =================== #

  def from_number(1), do: %Light.Red{}
  def from_number(2), do: %Light.Yellow{}
  def from_number(3), do: %Light.Green{}
end

Light.new()
#=> %Light.Red{}
```

## Embedded Products

Data with multiple fields can be defined directly as part of a sum

```elixir
defmodule Pet do
  defsum do
    defdata Cat do
      name :: String.t()
      claw_sharpness :: String.t()
    end

    defdata Dog do
      name :: String.t()
      bark_loudness :: non_neg_integer()
    end
  end
end
```

## Default Constructor

The first `defdata`'s constructor will be the default constructor for the sum

```elixir
defmodule Maybe do
  defsum do
    defdata Nothing :: none()
    defdata Just    :: any()
  end
end

Maybe.new()
#=> %Maybe.Nothing{}
```

## Tagged Unions

Sums join existing types with tags: new types to help distinguish the context
that they are in (the sum type)

```elixir
defdata Book  :: String.t() \\ "War and Peace"
defdata Video :: String.t() \\ "2001: A Space Odyssey"

defmodule Media do
  defsum do
    defdata Paper :: Book.t()
    defdata Film  :: Video.t() \\ Video.new("A Clockwork Orange")
  end
end

media = Media.new()
#=> %Paper{
#      paper: %Book{
#        book: "War and Peace"
#      }
#   }
```

# A Sampling of ADTs

See [complete docs](https://hexdocs.pm/algae) for more

## `Algae.Id`

The simplest ADT: a simple wrapper for some data

```elixir
%Algae.Id{id: "hi!"}
```

## `Algae.Maybe`

Maybe represents the presence or absence of something.

Please note that `nil` is actually a value, as it can be passed to functions!
`nil` is not bottom!

```elixir
Algae.Maybe.new()
#=> %Algae.Maybe.Nothing{}

Algae.Maybe.new(42)
#=> %Algae.Maybe.Just{just: 42}
```

## `Tree.BinarySearch`

```elixir
alias Algae.Tree.BinarySearch, as: BTree

#   42
#  /  \
# 77  1234
#     /  \
#    98  32

BTree.Branch.new(
  42,
  BTree.Branch.new(77),
  BTree.Branch.new(
    1234,
    BTree.Branch.new(98),
    BTree.Branch.new(32)
  )
)

#=> %Algae.Tree.BinarySearch.Branch{
#     value: 42,
#     left: %Algae.Tree.BinarySearch.Branch{
#       value: 77,
#       left:  %Algae.Tree.BinarySearch.Empty{},
#       right: %Algae.Tree.BinarySearch.Empty{}
#     },
#     right: %Algae.Tree.BinarySearch.Branch{
#       value: 1234,
#       left:  %Algae.Tree.BinarySearch.Branch{
#         value: 98,
#         left:  %Algae.Tree.BinarySearch.Empty{},
#         right: %Algae.Tree.BinarySearch.Empty{}
#       },
#       right: %Algae.Tree.BinarySearch.Branch{
#         value: 32,
#         left:  %Algae.Tree.BinarySearch.Empty{},
#         right: %Algae.Tree.BinarySearch.Empty{}
#       }
#     }
#   }
```
