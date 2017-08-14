alias Algae.Tree.BinarySearch, as: BST
alias Algae.Tree.BinarySearch.{Empty, Node}

import TypeClass

use Witchcraft

definst Witchcraft.Monoid, for: Algae.Tree.BinarySearch.Empty do
  def empty(empty), do: empty
end

definst Witchcraft.Monoid, for: Algae.Tree.BinarySearch.Node do
  def empty(_), do: %Empty{}
end
