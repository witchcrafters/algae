defmodule Algae.Id do
  @moduledoc ~S"""
  The simplest ADT: a simple wrapper for some data

  ## Examples

      iex> %Algae.Id{id: "hi!"}
      %Algae.Id{id: "hi!"}

  """

  import Algae

  defdata any()
end

import TypeClass

defimpl TypeClass.Property.Generator, for: Algae.Id do
  def generate(_), do: %Algae.Id{id: TypeClass.Property.Generator.generate(1)}
end

definst Witchcraft.Setoid, for: Algae.Id do
  def equivalent?(%{id: a}, %{id: b}), do: Witchcraft.Setoid.equivalent?(a, b)
end

definst Witchcraft.Ord, for: Algae.Id do
  def compare(%{id: a}, %{id: b}), do: Witchcraft.Ord.compare(a, b)
end

definst Witchcraft.Semigroup, for: Algae.Id do
  def append(%{id: a}, %{id: b}), do: %Algae.Id{id: Witchcraft.Semigroup.append(a, b)}
end

definst Witchcraft.Monoid, for: Algae.Id do
  def empty(%{id: sample}), do: %Algae.Id{id: Witchcraft.Monoid.empty(sample)}
end

definst Witchcraft.Functor, for: Algae.Id do
  def map(%{id: data}, fun), do: %Algae.Id{id: fun.(data)}
end

definst Witchcraft.Foldable, for: Algae.Id do
  def right_fold(%{id: data}, seed, fun), do: fun.(data, seed)
end

definst Witchcraft.Traversable, for: Algae.Id do
  def traverse(%{id: data}, link) do
    data
    |> link.()
    |> Witchcraft.Functor.map(fn x -> %Algae.Id{id: x} end)
  end
end
