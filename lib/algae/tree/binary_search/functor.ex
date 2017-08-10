alias Algae.Tree.BinarySearch, as: BST
alias Algae.Tree.BinarySearch.{Empty, Node}

import TypeClass

use Witchcraft

definst Witchcraft.Functor, for: Algae.Tree.BinarySearch.Empty do
  def map(_, _), do: %Empty{}
end

definst Witchcraft.Functor, for: Algae.Tree.BinarySearch.Node do
  def map(%Node{node: node, left: left, right: right}, fun) do
    %Node{
      node:  fun.(node),
      left:  left ~> fun,
      right: right ~> fun
    }
  end
end
