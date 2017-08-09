defmodule Algae.Free do
  @moduledoc """
  A "free" structure, similar to lists

  ## Shallow
  `Shallow` holds a plain value

  ## Deep

  `Deep` holds two values: a value (often a functor) in `deep`, and another
  `Algae.Free.t` in `deeper`

      %Free.Deep{
        deep:   %Id{id: 42},
        deeper: %Free.Shallow{shallow: "Terminus"}
      }

  """

  import Algae
  alias __MODULE__

  defsum do
    defdata Shallow :: any()

    defdata Deep do
      deep   :: any()
      deeper :: any() # Algae.Free.t()
    end
  end

  @doc """
  Create a `Algae.Free.Shallow` wrapping a single, simple value

  ## Examples

      iex> new(42)
      %Algae.Free.Shallow{shallow: 42}

  """
  @spec new(any()) :: t()
  def new(value), do: Free.Shallow.new(value)

  @doc """
  Add another layer to a free structure

  ## Examples

      iex> 13
      ...> |> new()
      ...> |> layer(42)
      0

  """
  @spec layer(t(), any()) :: t()
  def layer(free, value), do: %Deep{deep: value, deeper: %Free.Deep{deep: free}}
end

alias Alage.Free.{Deep, Shallow}
import TypeClass
use Witchcraft

#############
# Generator #
#############

defimpl TypeClass.Property.Generator, for: Shallow do
  def generate(_) do
    [1, 1.1, "", []]
    |> Enum.random()
    |> TypeClass.Property.Generator.generate()
    |> Shallow.new()
  end
end

defimpl TypeClass.Property.Generator, for: Deep do
  def generate(_) do
    [1, 1.1, "", []]
    |> Enum.random()
    |> TypeClass.Property.Generator.generate()
    |> Deep.new()
  end
end
