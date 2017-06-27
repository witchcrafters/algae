defmodule Algae.Maybe.Nothing do
  @moduledoc ~S"""
  An empty struct. Cannot accept any values. Represents the lack of a value.

  ## Examples

      iex> %Algae.Maybe.Nothing{}
      %Algae.Maybe.Nothing{}

  """

  alias __MODULE__

  @type t :: %Nothing{}
  defstruct []

  @doc ~S"""
  Create a new `Algae.Maybe.Nothing` struct.

  ## Examples

      iex> new()
      %Algae.Maybe.Nothing{}

  """
  @spec new() :: Nothing.t
  def new, do: %Nothing{}
end
