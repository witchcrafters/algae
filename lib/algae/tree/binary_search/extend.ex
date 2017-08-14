alias Algae.Tree.BinarySearch.{Empty, Node}
import TypeClass
use Witchcraft

definst Witchcraft.Extend, for: Algae.Tree.BinarySearch.Empty do
  def nest(_), do: %Empty{}
end

definst Witchcraft.Extend, for: Algae.Tree.BinarySearch.Node do
  def nest(tree = %Node{left: left, right: right}) do
    %Node{
      node:  tree,
      left:  Witchcraft.Extend.nest(left),
      right: Witchcraft.Extend.nest(right)
    }
  end
end
