defmodule AlgaeTest do
  alias Example.{Light, Wrapper, Media, Book, Animal, Pet}
  use ExUnit.Case

  test "constructor for empty type" do
    assert Example.Light.new() == %Example.Light.Red{}
  end

  test "constructor with one field" do
    assert %Example.Wrapper{} == %Wrapper{wrapper: nil}
  end

  test "constructor with multiple fields uses defaults" do
    crookshanks =
      %Animal{
        name: "Crookshanks",
        leg_count: 4
      }

    assert Animal.new("Crookshanks") == crookshanks
  end

  test "constructor with multiple fields can overwrite all fields" do
    paul =
      %Animal{
        name: "Paul the Psychic Octopus",
        leg_count: 8
      }

    assert Animal.new("Paul the Psychic Octopus", 8) == paul
  end

  test "sum constructor uses the first tagged type" do
    paper =
      %Media.Paper{
        paper: %Book{
          book: "War and Peace"
        }
      }

    assert Media.new() == paper
  end
end
