defmodule Algae.Tree do
  use Quark.Partial

  @type t :: Empty.t | Leaf.t | Branch.t

  defmodule Empty do
    @type t :: %Empty{}
    defstruct []
  end

  defmodule Leaf do
    @type t :: %Leaf{leaf: any}
    defstruct [:leaf]
  end

  defmodule Branch do
    @type t :: %Branch{left: Algae.Tree.t, right: Algae.Tree.t}
    defstruct [:left, :right]
  end

  def empty(), do: %Empty{}

  defpartial leaf(value), do: %Algae.Tree.Leaf{leaf: value}

  def branch(left: left, right: right), do: branch(left, right)
  defpartial branch(left, right), do: %Algae.Tree.Branch{left: left, right: right}

  def tree(), do: empty()

  def tree(left: left, right: right), do: branch(left, right)
  def tree(leaf: value), do: leaf(value)

  def tree(leaf_value), do: leaf(leaf_value)
  def tree(left, right), do: branch(left, right)
end
