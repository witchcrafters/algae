defmodule Algae.Maybe.Just do
  @moduledoc ~S"""
  A simple, single-value-wrapping struct, much like `Algae.Id`.
  Represents the presence of a value; one possible analog of `{:ok, value}`

  ## Examples

      iex> %Algae.Maybe.Just{just: 42}
      %Algae.Maybe.Just{just: 42}

  """

  alias __MODULE__

  @type t :: %Just{just: any}
  defstruct [:just]

  @doc ~S"""
  Wrap a value in a `Just` struct

  ## Examples

      iex> new(99)
      %Algae.Maybe.Just{just: 99}

  """
  @spec new(any) :: Just.t
  def new(value), do: %Just{just: value}
end
