defmodule Algae.Tree do
  @type t :: Leaf.t | Branch.t

  defmodule Leaf do
    @type t :: %Leaf{leaf: any}
    defstruct [:leaf]
  end

  defmodule Branch do
    @type t :: %Branch{left: Algae.Tree.t, right: Algae.Tree.t}
    defstruct [:left, :right]
  end

  def leaf(value), do: %Algae.Tree.Leaf{leaf: value}
  def branch(left, right), do: %Algae.Tree.branch{left: left, right: right}
  def branch(left: left, right: right), do: branch(left, right)
end

defimpl Witchcraft.Functor, for: Algae.Tree.Leaf do
  import Quark.Curry, only: [curry: 1]

  def lift(%Algae.Tree.Leaf{leaf: value}, fun), do
    curry(fun).(value) |> Algae.Tree.leaf
  end
end

defimpl Witchcraft.Functor, for: Algae.Tree.Branch do
  def lift(%Algae.Tree.Branch{left: left, right: right}, fun) do
    %Algae.Tree.Branch{
      left: lift(left, fun),
      right: lift(right, fun)
    }
  end
end
