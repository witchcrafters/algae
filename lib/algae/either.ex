defmodule Algae.Either do
  @moduledoc ~S"""
  Represent branching conditions. These could be different return types,
  error vs nominal value, and so on.

  ## Examples

      iex> require Integer
      ...>
      ...> even_odd = fn(value) ->
      ...>   if Integer.is_even(value) do
      ...>     Algae.Either.Right.new(value)
      ...>   else
      ...>     Algae.Either.Left.new(value)
      ...>   end
      ...> end
      ...>
      ...> even_odd.(10)
      %Algae.Either.Right{right: 10}
      ...> even_odd.(11)
      %Algae.Either.Left{left: 11}
  """

  import Algae

  defsum do
    defdata Left  :: any()
    defdata Right :: any()
  end
end
