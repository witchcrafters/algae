alias Algae.Tree.BinarySearch.{Empty, Node}
import TypeClass
use Witchcraft

definst Witchcraft.Chain, for: Algae.Tree.BinarySearch.Empty do
  def chain(_, _), do: %Empty{}
end

definst Witchcraft.Chain, for: Algae.Tree.BinarySearch.Node do
  def chain(%Node{node: node}, link), do: link.(node)
end
