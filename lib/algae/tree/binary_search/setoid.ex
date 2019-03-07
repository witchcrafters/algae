alias Algae.Tree.BinarySearch, as: BST
alias Algae.Tree.BinarySearch.{Empty, Node}

import TypeClass

use Witchcraft

definst Witchcraft.Setoid, for: Algae.Tree.BinarySearch.Empty do
  def equivalent?(_, %Empty{}), do: true
  def equivalent?(_, %Node{}),  do: false
end

definst Witchcraft.Setoid, for: Algae.Tree.BinarySearch.Node do
  def equivalent?(%Node{}, %Empty{}), do: false
  def equivalent?(%Node{node: a}, %Node{node: b}) do
    Witchcraft.Setoid.equivalent?(a, b)
  end
end
