defmodule Algae.Maybe do
  @moduledoc ~S"""
  The sum of `Algae.Maybe.Just` and `Algae.Maybe.Nothing`.
  May represents the presence or absence of something.

  Please note that `nil` is actually a value, as it can be passed to functions!
  `nil` is not bottom!

  ## Examples

      iex> [1,2,3]
      ...> |> Enum.filter(&(&1 > 1))
      ...> |> case do
      ...>      []   -> nothing
      ...>      list -> just(list)
      ...>    end
      %Algae.Maybe.Just{just: [2,3]}

      iex> [1,2,3]
      ...> |> Enum.filter(&(&1 > 100))
      ...> |> case do
      ...>      []   -> nothing
      ...>      list -> just(list)
      ...>    end
      %Algae.Maybe.Nothing{}

  """

  alias Algae.Maybe.Just
  alias Algae.Maybe.Nothing

  @type t :: Just.t | Nothing.t

  @doc ~S"""
  Put no value into the `Maybe` context (ie: make it a `Nothing`)

  ## Examples

      iex> maybe()
      %Algae.Maybe.Nothing{}

  """
  @spec maybe() :: Nothing.t
  defdelegate maybe, to: Nothing, as: :new

  @doc ~S"""
  Alias for `maybe/0`

  ## Examples

      iex> Algae.Maybe.nothing()
      %Algae.Maybe.Nothing{}

  """
  @spec nothing() :: Nothing.t
  defdelegate nothing, to: Nothing, as: :new

  @doc ~S"""
  Put a value into the `Maybe` context (ie: make it a `Just`)

  ## Examples

      iex> maybe(9)
      %Algae.Maybe.Just{just: 9}

  """
  @spec maybe(any) :: Just.t
  defdelegate maybe(value), to: Just, as: :new

  @doc ~S"""
  Alias for `maybe/1`

  ## Examples

      iex> Algae.Maybe.Just.new(9)
      %Algae.Maybe.Just{just: 9}

  """
  @spec just(any) :: Just.t
  defdelegate just(value), to: Just, as: :new
end
