defmodule AlgaeTest do
  use ExUnit.Case

  Example.Light.new()
  #=> %Light.Red{}


  Example.Option.new()
  #=> %Option.None{}


  media = Example.Media.new()
  #=> %Paper{
  #      paper: %Book{
  #        book: "War and Peace"
  #      }
  #   }


  Example.Nothing.new()
  #=> %Nothing{}
  %Example.Wrapper{}
  #=> %Wrapper{wrapper: nil}

  %Example.Id{}
  #=> %Id{id: nil}


  Example.Person.new("Rachel Weintraub")
  #=> %Person{
  #     name: "Rachel Weintraub",
  #     age:  0
  #   }


  Example.Animal.new("Crookshanks")
  #=> %Pet{
  #     name: "Crookshanks",
  #     leg_count: 4
  #   }

  Example.Animal.new("Paul the Psychic Octopus", 8)
  #=> %Pet{
  #     name: "Paul the Psychic Octopus",
  #     leg_count: 8
  #   }

  Example.Grocery.new()
  #=> %Grocery{
  #     item: {"Apple", 4, false}
  #   }
  fourty_two = Example.Constant.new(42)
  fourty_two.constant.(33)
  #=> 42

  assert media == media
end
