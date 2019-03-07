alias  Algae.Tree.BinarySearch.{Empty, Node}
alias  Witchcraft.Functor
import TypeClass

definst Witchcraft.Functor, for: Algae.Tree.BinarySearch.Empty do
  def map(_, _), do: %Empty{}
end

definst Witchcraft.Functor, for: Algae.Tree.BinarySearch.Node do
  def map(%Node{node: node, left: left, right: right}, fun) do
    %Node{
      node:  fun.(node),
      left:  Functor.map(left,  fun),
      right: Functor.map(right, fun)
    }
  end
end
