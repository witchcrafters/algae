defmodule Algae.Either do
  @moduledoc ~S"""
  Represent branching conditions. These could be different return types,
  error vs nominal value, and so on.


  """

  alias Algae.Either.Left
  alias Algae.Either.Right

  @type t :: Left.t | Right.t

  def left(value),  do: %Left{left: value}
  def right(value), do: %Right{right: value}
end
