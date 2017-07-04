# import Algae

# defmodule Player do
#   defdata do
#     name       :: String.t()
#     hit_points :: non_neg_integer()
#     experience :: non_neg_integer()
#   end

#   @spec attack(t(), t()) :: {t(), t()}
#   def attack(%{experience: xp} = player, %{hit_points: hp} = target) do
#     {
#       %{player | experience: xp + 50},
#       %{target | hit_points: hp - 10}
#     }
#   end
# end

# %Player{name: "Sir Bob", hit_points: 10, experience: 500}

defmodule AlgaeTest do
  use ExUnit.Case

  # doctest Algae, import: true

  # assert Player.new("hi") == %Player{}

  # doctest Algae.Id, import: true

  # doctest Algae.Maybe, import: true
  # doctest Algae.Maybe.Nothing, import: true
  # doctest Algae.Maybe.Just, import: true

  # doctest Algae.Either, import: true
  # doctest Algae.Either.Left, import: true
  # doctest Algae.Either.Right, import: true

  # doctest Algae.Reader, import: true
end
