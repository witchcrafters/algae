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
      %Algae.Free.Deep{
        deep: 42,
        deeper: %Algae.Free.Shallow{
          shallow: 13
        }
      }

  """
  @spec layer(t(), any()) :: t()
  def layer(free, value), do: %Deep{deep: value, deeper: free}
end

alias Algae.Free.{Deep, Shallow}
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

##########
# Setoid #
##########

definst Witchcraft.Setoid, for: Algae.Free.Shallow do
  custom_generator(_) do
    1
    |> TypeClass.Property.Generator.generate()
    |> Algae.Free.new()
  end

  def equivalent?(_, %Deep{}), do: false

  def equivalent?(%Shallow{shallow: a}, %Shallow{shallow: b}) do
    Witchcraft.Setoid.equivalent?(a, b)
  end
end

definst Witchcraft.Setoid, for: Algae.Free.Deep do
  custom_generator(_) do
    a = TypeClass.Property.Generator.generate(1)
    b = TypeClass.Property.Generator.generate(1)
    c = TypeClass.Property.Generator.generate(1)

    a
    |> Algae.Free.new()
    |> Algae.Free.layer(Algae.Free.new(b))
    |> Algae.Free.layer(Algae.Free.new(c))
  end

  def equivalent?(_, %Shallow{}), do: false

  def equivalent?(%Deep{deep: deep_a, deeper: deeper_a}, %Deep{deep: deep_b, deeper: deeper_b}) do
    Witchcraft.Setoid.equivalent?(deep_a, deep_b)
    and Witchcraft.Setoid.equivalent?(deeper_a, deeper_b)
  end
end
