defmodule Algae.Maybe.Just do
  @moduledoc ~S"""
  A simple, single-value-wrapping struct, much like `Algae.Id`.
  Represents the presence of a value; one possible analog of `{:ok, value}`

  ## Examples

      iex> %Just{}
      %Algae.Just{just: nil}

      iex> %Just{}
      %Algae.Maybe.Just{just: nil}

  """

  alias __MODULE__
  use Quark.Partial

  @type t :: %Just{just: any}
  defstruct [:just]

  defpartial new(value) when is_nil(value), do: %Just{value: value}
  defpartial new(value), do: %Just{value: value}
end
