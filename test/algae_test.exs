defmodule AlgaeTest do
  use ExUnit.Case

  doctest Algae.Id, import: true

  doctest Algae.Maybe, import: true
  doctest Algae.Maybe.Nothing, import: true
  doctest Algae.Maybe.Just, import: true

  doctest Algae.Either, import: true
  doctest Algae.Either.Left, import: true
  doctest Algae.Either.Right, import: true
end
