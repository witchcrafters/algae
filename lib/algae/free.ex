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

  alias  Alage.Free.{Pure, Roll}
  import Algae
  use    Witchcraft

  defsum do
    defdata Roll :: any() # Witchcraft.Functor.t()
    defdata Pure :: any() \\ %Witchcraft.Unit{}
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
