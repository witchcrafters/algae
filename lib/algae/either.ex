defmodule Algae.Either do
  @moduledoc ~S"""
  Represent branching conditions. These could be different return types,
  error vs nominal value, and so on.

  ## Examples

      iex> require Integer
      ...> value = 11
      ...> if Integer.is_even(value) do
      ...>   right(value)
      ...> else
      ...>   left(value)
      ...> end
      %Algae.Either.Left{left: 11}

      iex> require Integer
      ...> value = 10
      ...> if Integer.is_even(value) do
      ...>   right(value)
      ...> else
      ...>   left(value)
      ...> end
      %Algae.Either.Right{right: 10}

  """

  alias Algae.Either.Left
  alias Algae.Either.Right

  defmacro __using__(_) do
    quote do
      alias Algae.Either
      alias Algae.Either.Left
      alias Algae.Either.Right
    end
  end

  @type t :: Left.t | Right.t

  @doc ~S"""
  Wrap a value in the `Left` branch

  ## Examples

      iex> left(13)
      %Algae.Either.Left{left: 13}

  """
  @spec left(any) :: Left.t
  def left(value), do: value |> Left.new

  @doc ~S"""
  Wrap a value in the `Right` branch

  ## Examples

      iex> right(7)
      %Algae.Either.Right{right: 7}

  """
  @spec right(any) :: Right.t
  def right(value), do: value |> Right.new
end
