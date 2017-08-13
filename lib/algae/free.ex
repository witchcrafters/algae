defmodule Algae.Free do
  @moduledoc """
  A "free" structure, similar to lists but with the ability to add a struct
  "tag" at each level. Often used for DSLs, interpreters,
  or building structured data.

  ## Pure
  `Pure` simply holds a plain value.

      %Free.Pure{pure: 42}

  ## Roll

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
    defdata Pure :: any()
    defdata Roll :: any() # Algae.Free.t()
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
        roll: %Algae.Free.Pure{
          pure: 13
        }
      }

  """
  @spec layer(t(), any()) :: t()
  def layer(free, mutual), do: %Roll{roll: of(mutual, free)}
end
