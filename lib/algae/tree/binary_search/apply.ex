alias Algae.Tree.BinarySearch.{Empty, Node}
import TypeClass
use Witchcraft

definst Witchcraft.Apply, for: Algae.Tree.BinarySearch.Empty do
  def convey(_, _), do: %Empty{}
end

definst Witchcraft.Apply, for: Algae.Tree.BinarySearch.Node do
  def convey(_, %Empty{}), do: %Empty{}
  def convey(%{node: node, left: left, right: right}, tree_funs = %Node{node: fun}) do
    %Node{
      node:  fun.(node),
      left:  Witchcraft.Apply.convey(left,  tree_funs),
      right: Witchcraft.Apply.convey(right, tree_funs)
    }
  end
end
