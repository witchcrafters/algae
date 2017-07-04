defmodule Algae.Maybe do
  @moduledoc ~S"""
  The sum of `Algae.Maybe.Just` and `Algae.Maybe.Nothing`.
  Maybe represents the presence or absence of something.

  Please note that `nil` is actually a value, as it can be passed to functions!
  `nil` is not bottom!

  ## Examples

      iex> [1,2,3]
      ...> |> List.first()
      ...> |> case do
      ...>      nil  -> new()
      ...>      head -> new(head)
      ...>    end
      %Algae.Maybe.Just{just: 1}

      iex> []
      ...> |> List.first()
      ...> |> case do
      ...>      nil  -> new()
      ...>      head -> new(head)
      ...>    end
      %Algae.Maybe.Nothing{}

  """

  import Algae
  alias Algae.Maybe.{Nothing, Just}

  defsum do
    defdata Nothing :: none()

    defdata Just do
      value :: any()
    end
  end

  @doc ~S"""
  Put no value into the `Maybe` context (ie: make it a `Nothing`)

  ## Examples

      iex> new()
      %Algae.Maybe.Nothing{}

  """
  @spec new() :: Nothing.t()
  defdelegate new, to: Nothing, as: :new

  @doc ~S"""
  Put a value into the `Maybe` context (ie: make it a `Just`)

  ## Examples

      iex> new(9)
      %Algae.Maybe.Just{just: 9}

  """
  @spec new(any) :: Just.t()
  defdelegate new(value), to: Just, as: :new
end
