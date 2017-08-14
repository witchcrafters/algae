defmodule Algae.Maybe do
  @moduledoc ~S"""
  The sum of `Algae.Maybe.Just` and `Algae.Maybe.Nothing`.
  Maybe represents the presence or absence of something.

  Please note that `nil` is actually a value, as it can be passed to functions!
  `nil` is not bottom!

  ## Examples

      iex> [1,2,3]
      ...> |> List.first()
      ...> |> case do
      ...>      nil  -> new()
      ...>      head -> new(head)
      ...>    end
      %Algae.Maybe.Just{just: 1}

      iex> []
      ...> |> List.first()
      ...> |> case do
      ...>      nil  -> new()
      ...>      head -> new(head)
      ...>    end
      %Algae.Maybe.Nothing{}

  """

  import Algae
  alias Algae.Maybe.{Nothing, Just}

  defsum do
    defdata Nothing :: none()
    defdata Just    :: any()
  end

  @doc ~S"""
  Put no value into the `Maybe` context (ie: make it a `Nothing`)

  ## Examples

      iex> new()
      %Algae.Maybe.Nothing{}

  """
  @spec new() :: Nothing.t()
  defdelegate new, to: Nothing, as: :new

  @doc ~S"""
  Put a value into the `Maybe` context (ie: make it a `Just`)

  ## Examples

      iex> new(9)
      %Algae.Maybe.Just{just: 9}

  """
  @spec new(any) :: Just.t()
  defdelegate new(value), to: Just, as: :new

  @doc """
  Extract a value from a `Maybe`, falling back to a set value in the `Nothing` case.

  ## Examples

      iex> from_maybe(%Algae.Maybe.Nothing{}, else: 42)
      42

      iex> %Algae.Maybe.Just{just: 1955} |> from_maybe(else: 42)
      1955

  """
  @spec from_maybe(t(), any()) :: any()
  def from_maybe(%Nothing{}, [else: fallback]), do: fallback
  def from_maybe(%Just{just: inner}, _), do: inner
end

alias Algae.Maybe.{Just, Nothing}
import TypeClass
use Witchcraft

#############
# Generator #
#############

defimpl TypeClass.Property.Generator, for: Algae.Maybe.Nothing do
  def generate(_), do: Nothing.new()
end

defimpl TypeClass.Property.Generator, for: Algae.Maybe.Just do
  def generate(_) do
    [1, 1.1, "", []]
    |> Enum.random()
    |> TypeClass.Property.Generator.generate()
    |> Just.new()
  end
end

##########
# Setoid #
##########

definst Witchcraft.Setoid, for: Algae.Maybe.Nothing do
  def equivalent?(_, %Nothing{}), do: true
  def equivalent?(_, %Just{}),    do: false
end

definst Witchcraft.Setoid, for: Algae.Maybe.Just do
  def equivalent?(%Just{just: a}, %Just{just: b}), do: Witchcraft.Setoid.equivalent?(a, b)
  def equivalent?(%Just{}, %Nothing{}), do: false
end

#######
# Ord #
#######

definst Witchcraft.Ord, for: Algae.Maybe.Nothing do
  def compare(_, %Nothing{}), do: :equal
  def compare(_, %Just{}),    do: :lesser
end

definst Witchcraft.Ord, for: Algae.Maybe.Just do
  custom_generator(_) do
    1
    |> TypeClass.Property.Generator.generate()
    |> Just.new()
  end

  def compare(%Just{just: a}, %Just{just: b}), do: Witchcraft.Ord.compare(a, b)
  def compare(%Just{}, %Nothing{}), do: :greater
end

#############
# Semigroup #
#############

definst Witchcraft.Semigroup, for: Algae.Maybe.Nothing do
  def append(_, right), do: right
end

definst Witchcraft.Semigroup, for: Algae.Maybe.Just do
  custom_generator(_) do
    1
    |> TypeClass.Property.Generator.generate()
    |> Just.new()
  end

  def append(%Just{just: a}, %Just{just: b}), do: %Just{just: a <> b}
  def append(just, %Nothing{}), do: just
end

##########
# Monoid #
##########

definst Witchcraft.Monoid, for: Algae.Maybe.Nothing do
  def empty(nothing), do: nothing
end

definst Witchcraft.Monoid, for: Algae.Maybe.Just do
  def empty(_), do: %Algae.Maybe.Nothing{}
end

###########
# Functor #
###########

definst Witchcraft.Functor, for: Algae.Maybe.Nothing do
  def map(_, _), do: %Algae.Maybe.Nothing{}
end

definst Witchcraft.Functor, for: Algae.Maybe.Just do
  def map(%{just: data}, fun), do: data |> fun.() |> Algae.Maybe.Just.new()
end

############
# Foldable #
############

definst Witchcraft.Foldable, for: Algae.Maybe.Nothing do
  def right_fold(_, seed, _), do: seed
end

definst Witchcraft.Foldable, for: Algae.Maybe.Just do
  def right_fold(%Just{just: inner}, seed, fun), do: fun.(inner, seed)
end

###############
# Traversable #
###############

# Not traversable because we don't have enough type information for Nothing

#########
# Apply #
#########

definst Witchcraft.Apply, for: Algae.Maybe.Nothing do
  def convey(_, _), do: %Algae.Maybe.Nothing{}
end

definst Witchcraft.Apply, for: Algae.Maybe.Just do
  alias Algae.Maybe.{Just, Nothing}

  def convey(data, %Nothing{}), do: %Nothing{}
  def convey(data, %Just{just: fun}), do: map(data, fun)
end

###############
# Applicative #
###############

definst Witchcraft.Applicative, for: Algae.Maybe.Nothing do
  def of(_, data), do: Just.new(data)
end

definst Witchcraft.Applicative, for: Algae.Maybe.Just do
  def of(_, data), do: Just.new(data)
end

#########
# Chain #
#########

definst Witchcraft.Chain, for: Algae.Maybe.Nothing do
  def chain(_, _), do: %Nothing{}
end

definst Witchcraft.Chain, for: Algae.Maybe.Just do
  def chain(%{just: data}, link), do: link.(data)
end

#########
# Monad #
#########

definst Witchcraft.Monad, for: Algae.Maybe.Nothing
definst Witchcraft.Monad, for: Algae.Maybe.Just

##########
# Extend #
##########

definst Witchcraft.Extend, for: Algae.Maybe.Nothing do
  def nest(_), do: %Nothing{}
end

definst Witchcraft.Extend, for: Algae.Maybe.Just do
  def nest(inner), do: Just.new(inner)
end
