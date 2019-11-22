defmodule Algae.Free do
  @moduledoc """
  A "free" structure that converts functors into monads by embedding them in
  a special structure with all of the monadic heavy lifting done for you.

  Similar to trees and lists, but with the ability to add a struct "tag",
  at each level. Often used for DSLs, interpreters, or building structured data.

  For a simple introduction to the "free monad + interpreter" pattern, we recommend
  [Why free monads matter](http://www.haskellforall.com/2012/06/you-could-have-invented-free-monads.html).

  ## Anatomy

  ### Pure

  `Pure` simply holds a plain value.

      %Free.Pure{pure: 42}

  ### Roll

  `Roll` resursively containment of more `Free` structures embedded in
  a another ADT. For example, with `Id`:

      %Free.Roll{
        roll: %Id{
          id: %Pure{
            pure: 42
          }
        }
      }

  """

  alias __MODULE__
  alias Algae.Free.{Pure, Roll}

  import Algae

  use Witchcraft

  defsum do
    defdata(Roll :: any())
    defdata(Pure :: any() \\ %Witchcraft.Unit{})
  end

  @doc """
  Create an `Algae.Free.Pure` wrapping a single, simple value

  ## Examples

      iex> new(42)
      %Algae.Free.Pure{pure: 42}

  """
  @spec new(any()) :: t()
  def new(value), do: %Pure{pure: value}

  @doc """
  Add another layer to a free structure

  ## Examples

      iex> 13
      ...> |> new()
      ...> |> layer(%Algae.Id{})
      %Algae.Free.Roll{
        roll: %Algae.Id{
          id: %Algae.Free.Pure{
            pure: 13
          }
        }
      }

  """
  @spec layer(t(), any()) :: t()
  def layer(free, mutual), do: %Roll{roll: of(mutual, free)}

  @doc """
  Wrap a functor in a free structure.

  ## Examples

      iex> wrap(%Algae.Id{id: 42})
      %Algae.Free.Roll{
        roll: %Algae.Id{
          id: 42
        }
      }

  """
  @spec wrap(Witchcraft.Functor.t()) :: Roll.t()
  def wrap(functor), do: %Roll{roll: functor}

  @doc """
  Lift a plain functor up into a free monad.

  ## Examples

      iex> free(%Algae.Id{id: 42})
      %Algae.Free.Roll{
        roll: %Algae.Id{
          id: %Algae.Free.Pure{
            pure: 42
          }
        }
      }

  """
  @spec free(Witchcraft.Functor.t()) :: t()
  def free(functor) do
    functor
    |> map(&of(%Roll{}, &1))
    |> wrap()
  end
end

alias Algae.Free
alias Algae.Free.{Pure, Roll}
alias TypeClass.Property.Generator
alias Witchcraft.{Apply, Chain, Functor, Ord, Setoid}
import TypeClass
use Witchcraft

#############
# Generator #
#############

defimpl TypeClass.Property.Generator, for: Algae.Free.Pure do
  def generate(_) do
    [1, 1.1, "", []]
    |> Enum.random()
    |> Generator.generate()
    |> Pure.new()
  end
end

defimpl TypeClass.Property.Generator, for: Algae.Free.Roll do
  def generate(_) do
    inner = Algae.Id.new()

    seed =
      [1, 1.1, "", []]
      |> Enum.random()
      |> Generator.generate()

    seed
    |> Free.new()
    |> Free.layer(inner)
    |> Free.layer(inner)
  end
end

##########
# Setoid #
##########

definst Witchcraft.Setoid, for: Algae.Free.Pure do
  custom_generator(_) do
    1
    |> Generator.generate()
    |> Pure.new()
  end

  def equivalent?(_, %Roll{}), do: false
  def equivalent?(%Pure{pure: a}, %Pure{pure: b}), do: Setoid.equivalent?(a, b)
end

definst Witchcraft.Setoid, for: Algae.Free.Roll do
  custom_generator(_) do
    inner = Algae.Id.new()
    seed = Generator.generate(1)

    seed
    |> Free.new()
    |> Free.layer(inner)
    |> Free.layer(inner)
  end

  def equivalent?(_, %Pure{}), do: false
  def equivalent?(%Roll{roll: a}, %Roll{roll: b}), do: Setoid.equivalent?(a, b)
end

#######
# Ord #
#######

definst Witchcraft.Ord, for: Algae.Free.Pure do
  custom_generator(_) do
    1
    |> TypeClass.Property.Generator.generate()
    |> Free.new()
  end

  def compare(_, %Roll{}), do: :lesser
  def compare(%Pure{pure: a}, %Pure{pure: b}), do: Ord.compare(a, b)
end

definst Witchcraft.Ord, for: Algae.Free.Roll do
  custom_generator(_) do
    inner = Algae.Id.new()
    seed = Generator.generate(1)

    seed
    |> Free.new()
    |> Free.layer(inner)
    |> Free.layer(inner)
  end

  def compare(%Roll{}, %Pure{}), do: :greater
  def compare(%Roll{roll: a}, %Roll{roll: b}), do: Ord.compare(a, b)
end

###########
# Functor #
###########

definst Witchcraft.Functor, for: Algae.Free.Pure do
  def map(%Pure{pure: data}, fun), do: %Pure{pure: fun.(data)}
end

definst Witchcraft.Functor, for: Algae.Free.Roll do
  def map(%Roll{roll: data}, fun) do
    data
    |> Functor.map(&Functor.map(&1, fun))
    |> Roll.new()
  end
end

#########
# Apply #
#########

definst Witchcraft.Apply, for: Algae.Free.Pure do
  def convey(%Pure{pure: data}, %Pure{pure: fun}), do: %Pure{pure: fun.(data)}

  def convey(pure, %Roll{roll: rolled}) do
    rolled
    |> Functor.map(&Apply.convey(pure, &1))
    |> Roll.new()
  end
end

definst Witchcraft.Apply, for: Algae.Free.Roll do
  def convey(%Roll{roll: rolled}, %Pure{pure: fun}) do
    rolled
    |> Functor.map(&Functor.map(&1, fun))
    |> Roll.new()
  end

  def convey(roll, %Roll{roll: rolled}) do
    rolled
    |> Functor.map(&Apply.convey(roll, &1))
    |> Roll.new()
  end
end

###############
# Applicative #
###############

definst Witchcraft.Applicative, for: Algae.Free.Pure do
  def of(_, value), do: %Pure{pure: value}
end

definst Witchcraft.Applicative, for: Algae.Free.Roll do
  def of(_, value), do: %Pure{pure: value}
end

#########
# Chain #
#########

definst Witchcraft.Chain, for: Algae.Free.Pure do
  def chain(%Pure{pure: pure}, link), do: link.(pure)
end

definst Witchcraft.Chain, for: Algae.Free.Roll do
  def chain(%Roll{roll: rolled}, link) do
    rolled
    |> Functor.map(&Chain.chain(&1, link))
    |> Roll.new()
  end
end

#########
# Monad #
#########

definst(Witchcraft.Monad, for: Algae.Free.Pure)
definst(Witchcraft.Monad, for: Algae.Free.Roll)
