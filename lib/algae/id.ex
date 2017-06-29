defmodule Algae.Id do
  @moduledoc ~S"""
  The simplest ADT: a simple wrapper for some data

  ## Examples

      %Algae.Id{id: "hi!"}
  """

  alias __MODULE__

  @type t :: %Id{id: any()}
  defstruct [:id]

  @doc ~S"""
  A value wrapped in an `Id` struct.

  ## Examples

      iex> id("Bourne")
      %Algae.Id{id: "Bourne"}

      iex> 42 |> id()
      %Algae.Id{id: 42}

  """
  @spec id(any) :: Id.t()
  def id(value), do: %Id{id: value}

  @doc ~S"""
  An alias for `id`.

  ## Examples

      iex> Algae.Id.new("value")
      %Algae.Id{id: "value"}

  """
  @spec new(any) :: Id.t()
  def new(value), do: id(value)
end
