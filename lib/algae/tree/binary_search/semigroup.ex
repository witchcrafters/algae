alias Algae.Tree.BinarySearch, as: BST
alias Algae.Tree.BinarySearch.{Empty, Node}

import TypeClass
use Witchcraft

definst Witchcraft.Semigroup, for: Algae.Tree.BinarySearch.Empty do
  def append(_, %Empty{}),       do: %Empty{}
  def append(_, node = %Node{}), do: node
end

definst Witchcraft.Semigroup, for: Algae.Tree.BinarySearch.Node do
  def append(node, %Empty{}), do: node
  def append(node_a, node_b) do
    node_a
    |> BST.to_list()
    |> Enum.concat(BST.to_list(node_b))
    |> BST.from_list()
  end
end
