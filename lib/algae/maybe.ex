defmodule Algae.Maybe do
  @moduledoc ~S"""
  The sum of `Algae.Maybe.Just` and `Algae.Maybe.Nothing`.
  May represents the presence or absence of something.

  Please note that `nil` is actually a value, as it can be passed to functions!
  `nil` is not bottom!

  ## Examples

      iex> [1,2,3]
      ...> |> List.first
      ...> |> case do
      ...>      nil  -> nothing
      ...>      head -> just(head)
      ...>    end
      %Algae.Maybe.Just{just: 1}

      iex> []
      ...> |> List.first
      ...> |> case do
      ...>      nil  -> nothing
      ...>      head -> just(head)
      ...>    end
      %Algae.Maybe.Nothing{}

  """

  alias Algae.Maybe.Just
  alias Algae.Maybe.Nothing

  defmacro __using__(_) do
    quote do
      alias Algae.Maybe
      alias Algae.Maybe.Nothing
      alias Algae.Maybe.Just
    end
  end

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
