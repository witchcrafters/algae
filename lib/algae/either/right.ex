defmodule Algae.Either.Right do
  @moduledoc ~S"""
  Represent one side of a branching condition. In the case of representing
  potential error conditions, `Right` is traditionally associated with
  the nominal branch.

  ## Examples

      iex> %Algae.Either.Right{right: 88}
      %Algae.Either.Right{right: 88}
  """

  alias __MODULE__

  @type t :: %Right{right: any}
  defstruct [:right]

  @doc ~S"""
  Wrap a value in a `Right` struct

  ## Examples

      iex> new("here")
      %Algae.Either.Right{right: "here"}

  """
  @spec new(any) :: Right.t()
  def new(value), do: %Right{right: value}
end
