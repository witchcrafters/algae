defmodule AlgaeTest do
  alias Example.{Animal, Book, Media, Wrapper}
  use ExUnit.Case

  doctest Algae, import: true
  doctest Algae.Id, import: true

  doctest Algae.Maybe,  import: true
  doctest Algae.Either, import: true

  doctest Algae.Free, import: true

  doctest Algae.Tree.BinarySearch, import: true
  doctest Algae.Tree.Rose,         import: true

  doctest Algae.Reader, import: true
  doctest Algae.Writer, import: true
  doctest Algae.State,  import: true

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

  test "test either keeps left state using convey" do
    use Witchcraft
    r = Algae.Either.Right.new( "right!" )
    r? = Algae.Either.Right.new( fn x -> "who's there? " <> x end )
    l = Algae.Either.Left.new( "left the building!!!" )

    assert r |> convey( r? ) == Algae.Either.Right.new( "who's there? right!" ) 
    assert l |> convey( r? ) == l 
    assert l |> convey( l ) == l 
    assert r |> convey( l ) == l 
  end

end
