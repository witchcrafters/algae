defmodule Algae.Result do
  @moduledoc ~S"""
  Data type representing a result.
  A result can either be a successful `Ok` or an unsuccessful `Err`.

  ## Examples

      iex> load_planet = fn(planet, universe) ->
      ...>   if planet == "☄️",
      ...>     do: %Algae.Result.Err{err: "That's not a planet!"},
      ...>   else: %Algae.Result.Ok{ok: [planet | universe]}
      ...> end
      ...>
      ...> load_planet.("🌏", ["🌕"])
      %Algae.Result.Ok{ok: ["🌏", "🌕"]}
      ...> load_planet.("☄️", [])
      %Algae.Result.Err{err: "That's not a planet!"}
  """

  import Algae
  alias Witchcraft.{Chain, Foldable}

  defsum do
    defdata Err :: any()
    defdata Ok  :: any()
  end

  @doc """
  iex> is_error(%Algae.Result.Err{})
  true

  iex> is_error(%Algae.Result.Ok{})
  false
  """
  @spec is_error(t) :: boolean
  def is_error(%Err{}), do: true
  def is_error(%Ok{}), do: false

  @doc """
  iex> is_ok(%Algae.Result.Ok{})
  true

  iex> is_ok(%Algae.Result.Err{})
  false
  """
  @spec is_ok(t) :: boolean
  def is_ok(%Err{}), do: false
  def is_ok(%Ok{}), do: true

  @doc """
  Chain a whole list of results.

  iex> chain_list(
  ...>   Algae.Result.Ok.new(0), [1, 1, 1], fn result, number ->
  ...>     Algae.Result.Ok.new(result + number)
  ...>   end
  ...> )
  Algae.Result.Ok.new(3)

  """
  @spec chain_list(list(any), t, (any, any -> t)) :: t
  def chain_list(initial_result, stuff, handle) do
    Foldable.left_fold(
      stuff,
      initial_result,
      &Chain.chain(&1, fn x -> handle.(x, &2) end)
    )
  end

  @doc """
  Change an error.

  iex> map_error(Algae.Result.Err.new("a"), "b")
  %Algae.Result.Err{err: "b"}

  iex> map_error(Algae.Result.Ok.new("a"), "b")
  %Algae.Result.Ok{ok: "a"}
  """
  @spec map_error(t, any) :: t
  def map_error(%Err{}, new_error), do: Err.new(new_error)
  def map_error(ok, _), do: ok

  @doc """
  If a value is nil, return an `Err`, otherwise `Ok`.

  iex> is_error(from_nillable(nil))
  true

  iex> is_ok(from_nillable("Zed's not dead!"))
  true
  """
  def from_nillable(nil), do: Err.new("Cannot be nil")
  def from_nillable(value), do: Ok.new(value)

  @doc """
  Reduce a result to a value.
  You must provide a default value in case the result is an error.

  iex> from_result(Algae.Result.Ok.new(1), else: 2)
  1

  iex> from_result(Algae.Result.Err.new("error"), else: 2)
  2
  """
  def from_result(%Ok{ok: ok}, else: _), do: ok
  def from_result(%Err{}, else: default), do: default

  @doc """
  Rescue an `Err` by providing a fallback value.

  iex> fallback(Algae.Result.Err.new(), "fallback")
  %Algae.Result.Ok{ok: "fallback"}

  iex> fallback(Algae.Result.Ok.new("original"), "fallback")
  %Algae.Result.Ok{ok: "original"}
  """
  def fallback(%Err{}, fallback), do: Ok.new(fallback)
  def fallback(ok, _), do: ok
end

alias Algae.Result.{Err, Ok}
import TypeClass
use Witchcraft

#############
# Generator #
#############

defimpl TypeClass.Property.Generator, for: Err do
  def generate(_) do
    [1, 1.1, "", []]
    |> Enum.random()
    |> TypeClass.Property.Generator.generate()
    |> Err.new()
  end
end

defimpl TypeClass.Property.Generator, for: Ok do
  def generate(_) do
    [1, 1.1, "", []]
    |> Enum.random()
    |> TypeClass.Property.Generator.generate()
    |> Ok.new()
  end
end

##########
# Setoid #
##########

definst Witchcraft.Setoid, for: Err do
  def equivalent?(_, %Ok{}), do: false
  def equivalent?(%Err{err: a}, %Err{err: b}), do: Witchcraft.Setoid.equivalent?(a, b)
end

definst Witchcraft.Setoid, for: Ok do
  def equivalent?(_, %Err{}), do: false
  def equivalent?(%Ok{ok: a}, %Ok{ok: b}), do: Witchcraft.Setoid.equivalent?(a, b)
end

#######
# Ord #
#######

definst Witchcraft.Ord, for: Err do
  custom_generator(_) do
    1
    |> TypeClass.Property.Generator.generate()
    |> Err.new()
  end

  def compare(_, %Ok{}), do: :lesser
  def compare(%Err{err: a}, %Err{err: b}), do: Witchcraft.Ord.compare(a, b)
end

definst Witchcraft.Ord, for: Ok do
  custom_generator(_) do
    1
    |> TypeClass.Property.Generator.generate()
    |> Ok.new()
  end

  def compare(_, %Err{}), do: :greater
  def compare(%Ok{ok: a}, %Ok{ok: b}), do: Witchcraft.Ord.compare(a, b)
end

#############
# Semigroup #
#############

definst Witchcraft.Semigroup, for: Err do
  custom_generator(_) do
    1
    |> TypeClass.Property.Generator.generate()
    |> Err.new()
  end

  def append(err, %Ok{}), do: err
  def append(%Err{err: a}, %Err{err: b}), do: %Err{err: a <> b}
end

definst Witchcraft.Semigroup, for: Ok do
  custom_generator(_) do
    1
    |> TypeClass.Property.Generator.generate()
    |> Ok.new()
  end

  def append(_, err = %Err{}), do: err
  def append(%Ok{ok: a}, %Ok{ok: b}), do: %Ok{ok: a <> b}
end

##########
# Monoid #
##########

definst Witchcraft.Monoid, for: Err do
  def empty(%Err{err: a}), do: %Ok{ok: Witchcraft.Monoid.empty(a)}
end

definst Witchcraft.Monoid, for: Ok do
  def empty(%Ok{ok: a}), do: %Ok{ok: Witchcraft.Monoid.empty(a)}
end

###########
# Functor #
###########

definst Witchcraft.Functor, for: Err do
  def map(err, _), do: err
end

definst Witchcraft.Functor, for: Ok do
  def map(%Ok{ok: data}, fun), do: data |> fun.() |> Ok.new()
end

############
# Foldable #
############

definst Witchcraft.Foldable, for: Err do
  def right_fold(_, seed, _), do: seed
end

definst Witchcraft.Foldable, for: Ok do
  def right_fold(%Ok{ok: inner}, seed, fun), do: fun.(inner, seed)
end

###############
# Traversable #
###############

definst Witchcraft.Traversable, for: Err do
  @force_type_instance true

  def traverse(err = %Err{err: value}, link) do
    value
    |> link.()
    |> of(err)
  end
end

definst Witchcraft.Traversable, for: Ok do
  def traverse(%Ok{ok: value}, link), do: map(link.(value), &Ok.new/1)
end

#########
# Apply #
#########

definst Witchcraft.Apply, for: Err do
  def convey(err, _), do: err
end

definst Witchcraft.Apply, for: Ok do
  def convey(_,    %Err{}), do: %Err{}
  def convey(data, %Ok{ok: fun}), do: map(data, fun)
end

###############
# Applicative #
###############

definst Witchcraft.Applicative, for: Err do
  @force_type_instance true

  def of(_, data), do: Ok.new(data)
end

definst Witchcraft.Applicative, for: Ok do
  def of(_, data), do: Ok.new(data)
end

#########
# Chain #
#########

definst Witchcraft.Chain, for: Err do
  def chain(err, _), do: err
end

definst Witchcraft.Chain, for: Ok do
  def chain(%Ok{ok: data}, link), do: link.(data)
end

#########
# Monad #
#########

definst Witchcraft.Monad, for: Err
definst Witchcraft.Monad, for: Ok

##########
# Extend #
##########

definst Witchcraft.Extend, for: Err do
  def nest(_), do: Err.new()
end

definst Witchcraft.Extend, for: Ok do
  def nest(inner), do: Ok.new(inner)
end
