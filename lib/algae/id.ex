defmodule Algae.Id do
  @moduledoc ~S"""
  The simplest ADT: a simple wrapper for some data

  ## Examples

      iex> %Algae.Id{id: "hi!"}
      %Algae.Id{id: "hi!"}

  """

  import Algae

  defdata any()

  @doc """
  Wrap some data in an `Algae.Id` wrapper

  ## Examples

      iex> new(42)
      %Algae.Id{id: 42}

  """
  @spec new(any()) :: t()
  def new(inner), do: %Algae.Id{id: inner}
end

import TypeClass
use Witchcraft

defimpl TypeClass.Property.Generator, for: Algae.Id do
  def generate(_) do
    [1, 1.1, "", []]
    |> Enum.random()
    |> TypeClass.Property.Generator.generate()
    |> Algae.Id.new()
  end
end

definst Witchcraft.Setoid, for: Algae.Id do
  def equivalent?(%{id: a}, %{id: b}), do: a == b
end

definst Witchcraft.Ord, for: Algae.Id do
  custom_generator(_) do
    1
    |> TypeClass.Property.Generator.generate()
    |> Algae.Id.new()
  end

  def compare(%{id: a}, %{id: b}), do: Witchcraft.Ord.compare(a, b)
end

definst Witchcraft.Semigroup, for: Algae.Id do
  custom_generator(_) do
    1
    |> TypeClass.Property.Generator.generate()
    |> Algae.Id.new()
  end

  def append(%{id: a}, %{id: b}), do: %Algae.Id{id: a <> b}
end

definst Witchcraft.Monoid, for: Algae.Id do
  def empty(%{id: sample}), do: sample |> Witchcraft.Monoid.empty() |> Algae.Id.new()
end

definst Witchcraft.Functor, for: Algae.Id do
  def map(%{id: data}, fun), do: data |> fun.() |> Algae.Id.new()
end

definst Witchcraft.Foldable, for: Algae.Id do
  def right_fold(%{id: data}, seed, fun), do: fun.(data, seed)
end

definst Witchcraft.Traversable, for: Algae.Id do
  def traverse(%{id: data}, link) do
    data
    |> link.()
    |> Witchcraft.Functor.map(&Algae.Id.new/1)
  end
end

definst Witchcraft.Apply, for: Algae.Id do
  def convey(data, %{id: fun}), do: Witchcraft.Functor.map(data, fun)
end

definst Witchcraft.Applicative, for: Algae.Id do
  def of(_, data), do: Algae.Id.new(data)
end

definst Witchcraft.Chain, for: Algae.Id do
  def chain(%{id: data}, link), do: link.(data)
end

definst Witchcraft.Monad, for: Algae.Id

definst Witchcraft.Extend, for: Algae.Id do
  def nest(inner), do: Algae.Id.new(inner)
end

definst Witchcraft.Comonad, for: Algae.Id do
  def extract(%{id: inner}), do: inner
end
