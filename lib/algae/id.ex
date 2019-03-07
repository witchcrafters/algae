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
