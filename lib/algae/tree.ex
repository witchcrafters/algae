defmodule Algae.Tree do
  @moduledoc """
  Represent a binary tree.
  Nodes may be empty, a leaf, or a branch (recursive subtree).

  ## Examples

      %Algae.Tree.Branch{
        left:  %Algae.Tree.Empty{},
        right: %Algae.Tree.Leaf{leaf: 42}
      }

  """

  use Quark.Partial

  alias __MODULE__
  @type t :: Empty.t() | Leaf.t() | Branch.t()

  defmodule Empty do
    @moduledoc "An empty tree node"

    @type t :: %Empty{}
    defstruct []
  end

  defmodule Leaf do
    @moduledoc "A node containing a single value"

    @type t :: %Leaf{leaf: any}
    defstruct [:leaf]
  end

  defmodule Branch do
    @moduledoc "A subtree containing left and right nodes"

    @type t :: %Branch{left: Tree.t(), right: Tree.t()}
    defstruct [:left, :right]
  end

  @spec empty() :: t()
  def empty, do: %Empty{}

  defpartial leaf(value), do: %Algae.Tree.Leaf{leaf: value}

  def branch(left: left, right: right), do: branch(left, right)
  def branch(left, right), do: %Tree.Branch{left: left, right: right}

  @spec tree() :: Empty.t()
  def tree, do: empty()

  @spec tree(keyword() | any()) :: Branch.t()
  def tree(left: left, right: right), do: branch(left, right)
  def tree(leaf: value), do: leaf(value)
  def tree(leaf_value), do: leaf(leaf_value)

  @spec tree(any(), any()) :: Branch.t()
  def tree(left, right), do: branch(left, right)
end
