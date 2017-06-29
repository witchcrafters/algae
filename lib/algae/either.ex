defmodule Algae.Either do
  @moduledoc ~S"""
  Represent branching conditions. These could be different return types,
  error vs nominal value, and so on.

  ## Examples

      iex> require Integer
      ...>
      ...> even_odd = fn(value) ->
      ...>   if Integer.is_even(value) do
      ...>     right(value)
      ...>   else
      ...>     left(value)
      ...>   end
      ...> end
      ...>
      ...> even_odd.(10)
      %Algae.Either.Right{right: 10}
      ...> even_odd.(11)
      %Algae.Either.Left{left: 11}
  """

  alias Algae.Either.Left
  alias Algae.Either.Right

  defmacro __using__(_) do
    quote do
      alias Algae.Either
      alias Algae.Either.{Left, Right}
    end
  end

  @type t :: Left.t() | Right.t()

  @doc ~S"""
  Wrap a value in the `Left` branch

  ## Examples

      iex> left(13)
      %Algae.Either.Left{left: 13}
  """
  @spec left(any) :: Left.t()
  def left(value), do: Left.new(value)

  @doc ~S"""
  Wrap a value in the `Right` branch

  ## Examples

      iex> right(7)
      %Algae.Either.Right{right: 7}
  """
  @spec right(any) :: Right.t()
  def right(value), do: Right.new(value)
end
