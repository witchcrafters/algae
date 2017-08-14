defmodule Algae.Either do
  @moduledoc ~S"""
  Represent branching conditions. These could be different return types,
  error vs nominal value, and so on.

  ## Examples

      iex> require Integer
      ...>
      ...> even_odd = fn(value) ->
      ...>   if Integer.is_even(value) do
      ...>     Algae.Either.Right.new(value)
      ...>   else
      ...>     Algae.Either.Left.new(value)
      ...>   end
      ...> end
      ...>
      ...> even_odd.(10)
      %Algae.Either.Right{right: 10}
      ...> even_odd.(11)
      %Algae.Either.Left{left: 11}
  """

  import Algae

  defsum do
    defdata Left  :: any()
    defdata Right :: any()
  end
end

alias Algae.Either.{Left, Right}
import TypeClass
use Witchcraft

#############
# Generator #
#############

defimpl TypeClass.Property.Generator, for: Algae.Either.Left do
  def generate(_) do
    [1, 1.1, "", []]
    |> Enum.random()
    |> TypeClass.Property.Generator.generate()
    |> Algae.Either.Left.new()
  end
end

defimpl TypeClass.Property.Generator, for: Algae.Either.Right do
  def generate(_) do
    [1, 1.1, "", []]
    |> Enum.random()
    |> TypeClass.Property.Generator.generate()
    |> Algae.Either.Right.new()
  end
end

##########
# Setoid #
##########

definst Witchcraft.Setoid, for: Algae.Either.Left do
  def equivalent?(_, %Right{}), do: false
  def equivalent?(%Left{left: a}, %Left{left: b}), do: Witchcraft.Setoid.equivalent?(a, b)
end

definst Witchcraft.Setoid, for: Algae.Either.Right do
  def equivalent?(_, %Left{}), do: false
  def equivalent?(%Right{right: a}, %Right{right: b}), do: Witchcraft.Setoid.equivalent?(a, b)
end

#######
# Ord #
#######

definst Witchcraft.Ord, for: Algae.Either.Left do
  custom_generator(_) do
    1
    |> TypeClass.Property.Generator.generate()
    |> Left.new()
  end

  def compare(_, %Algae.Either.Right{}), do: :lesser
  def compare(%Left{left: a}, %Left{left: b}), do: Witchcraft.Ord.compare(a, b)
end

definst Witchcraft.Ord, for: Algae.Either.Right do
  custom_generator(_) do
    1
    |> TypeClass.Property.Generator.generate()
    |> Right.new()
  end

  def compare(_, %Left{}), do: :greater
  def compare(%Right{right: a}, %Right{right: b}), do: Witchcraft.Ord.compare(a, b)
end

#############
# Semigroup #
#############

definst Witchcraft.Semigroup, for: Algae.Either.Left do
  custom_generator(_) do
    1
    |> TypeClass.Property.Generator.generate()
    |> Left.new()
  end

  def append(left, %Right{}), do: left
  def append(%Left{left: a}, %Left{left: b}), do: %Left{left: a <> b}
end

definst Witchcraft.Semigroup, for: Algae.Either.Right do
  custom_generator(_) do
    1
    |> TypeClass.Property.Generator.generate()
    |> Algae.Either.Right.new()
  end

  def append(_, left = %Left{}), do: left
  def append(%Right{right: a}, %Right{right: b}), do: %Right{right: a <> b}
end

##########
# Monoid #
##########

definst Witchcraft.Monoid, for: Algae.Either.Left do
  def empty(%Left{left: a}), do: %Right{right: Witchcraft.Monoid.empty(a)}
end

definst Witchcraft.Monoid, for: Algae.Either.Right do
  def empty(%Right{right: a}), do: %Right{right: Witchcraft.Monoid.empty(a)}
end

# ###########
# # Functor #
# ###########

definst Witchcraft.Functor, for: Algae.Either.Left do
  def map(left, _), do: left
end

definst Witchcraft.Functor, for: Algae.Either.Right do
  def map(%Right{right: data}, fun), do: data |> fun.() |> Right.new()
end

# ############
# # Foldable #
# ############

definst Witchcraft.Foldable, for: Algae.Either.Left do
  def right_fold(_, seed, _), do: seed
end

definst Witchcraft.Foldable, for: Algae.Either.Right do
  def right_fold(%Right{right: inner}, seed, fun), do: fun.(inner, seed)
end

# ###############
# # Traversable #
# ###############

definst Witchcraft.Traversable, for: Algae.Either.Left do
  @force_type_instance true

  def traverse(left = %Left{left: value}, link) do
    value
    |> link.()
    |> of(left)
  end
end

definst Witchcraft.Traversable, for: Algae.Either.Right do
  def traverse(%Right{right: value}, link), do: map(link.(value), &Right.new/1)
end

# #########
# # Apply #
# #########

definst Witchcraft.Apply, for: Algae.Either.Left do
  def convey(left, _), do: left
end

definst Witchcraft.Apply, for: Algae.Either.Right do
  def convey(_,    %Left{}), do: %Left{}
  def convey(data, %Right{right: fun}), do: map(data, fun)
end

###############
# Applicative #
###############

definst Witchcraft.Applicative, for: Algae.Either.Left do
  @force_type_instance true

  def of(_, data), do: Right.new(data)
end

definst Witchcraft.Applicative, for: Algae.Either.Right do
  def of(_, data), do: Right.new(data)
end

# #########
# # Chain #
# #########

definst Witchcraft.Chain, for: Algae.Either.Left do
  def chain(left, _), do: left
end

definst Witchcraft.Chain, for: Algae.Either.Right do
  def chain(%Right{right: data}, link), do: link.(data)
end

# #########
# # Monad #
# #########

definst Witchcraft.Monad, for: Algae.Either.Left
definst Witchcraft.Monad, for: Algae.Either.Right

# ##########
# # Extend #
# ##########

definst Witchcraft.Extend, for: Algae.Either.Left do
  def nest(_), do: Left.new()
end

definst Witchcraft.Extend, for: Algae.Either.Right do
  def nest(inner), do: Right.new(inner)
end
