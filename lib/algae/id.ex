defmodule Algae.Id do
  @moduledoc ~S"""
  A simple wrapper for some data. This can be seen as a prototypical ADT.
  """

  @type t :: %Algae.Id{id: any}
  defstruct [:id]

  def id(), do: %Algae.Id{}
  def id(value), do: %Algae.Id{id: value}
end

defimpl Witchcraft.Functor, for: Algae.Id do
  def lift(%Algae.Id{id: value}, fun), do: Algae.id Quark.Curry.curry(fun).(value)
end
