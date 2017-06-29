defmodule Algae.Kleisli do
  use Quark.Partial

  @moduledoc ~S"""
  Kleisli helps to define Kleisli categories (and monadic arrows). The objects of
  this category are members of an underlying type, and the arrows between them.
  The arrows have an actual type of `X -> T(Y)`, but by the nature of the category,
  are thought of as simply `X -> Y`.

  The construction here is only concerned with morphisms, as any compatible datatype
  can be used as objects in the category. As mentioned above, `morphism` should be
  of type `a -> %New{new_data: b}`, or similar.

  Put another way, the morphism should both transform the data, and place it in a
  datatype. The morphism *could* be `id`, and the datatype *could* be the same,
  but generally change.
  """

  @type t :: %Algae.Kleisli{morphism: fun}
  defstruct [:morphism]

  @spec kleisli(fun) :: Algae.Kleisli.t()
  defpartial kleisli(morphism), do: %Algae.Kleisli{morphism: morphism}
end
