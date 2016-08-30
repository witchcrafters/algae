defmodule Algae.Either.Left do
  @moduledoc ~S"""
  Represent one side of a branching condition. In the case of representing
  potential error conditions, `Left` is traditionally associated with
  the error branch.

  ## Examples

      iex> %Algae.Either.Left{left: ArgumentError.exception("oopsie")}
      %Algae.Either.Left{
        left: %ArgumentError{message: "oopsie"}
      }

  """

  alias __MODULE__

  @type t :: %Left{left: any}
  defstruct [:left]

  @doc ~S"""
  Wrap a value in a `Left` struct

  ## Examples

      iex> new("field")
      %Algae.Either.Left{left: "field"}

  """
  @spec new(any) :: Left.t
  def new(value), do: %Left{left: value}
end
