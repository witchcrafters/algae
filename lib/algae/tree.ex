defmodule Algae.Tree do
  use Quark.Partial

  @type t :: Leaf.t | Branch.t

  defmodule Leaf do
    @type t :: %Leaf{leaf: any}
    defstruct [:leaf]
  end

  defmodule Branch do
    @type t :: %Branch{left: Algae.Tree.t, right: Algae.Tree.t}
    defstruct [:left, :right]
  end

  defpartial leaf(value), do: %Algae.Tree.Leaf{leaf: value}

  def branch(left: left, right: right), do: branch(left, right)
  defpartial branch(left, right), do: %Algae.Tree.Branch{left: left, right: right}
end

defimpl Witchcraft.Functor, for: Algae.Tree.Leaf do
  def lift(%Algae.Tree.Leaf{leaf: value}, fun) do
    Quark.Curry.curry(fun).(value) |> Algae.Tree.leaf
  end
end

defimpl Witchcraft.Functor, for: Algae.Tree.Branch do
  def lift(%Algae.Tree.Branch{left: left, right: right}, fun) do
    %Algae.Tree.Branch{
      left: lift(left, Quark.Curry.curry(fun)),
      right: lift(right, Quark.Curry.curry(fun))
    }
  end
end
