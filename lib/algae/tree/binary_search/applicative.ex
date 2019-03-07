alias  Algae.Tree.BinarySearch.Node
import TypeClass
use    Witchcraft

definst Witchcraft.Applicative, for: Algae.Tree.BinarySearch.Empty do
  def of(_, data), do: %Node{node: data}
end

definst Witchcraft.Applicative, for: Algae.Tree.BinarySearch.Node do
  @force_type_instance true
  def of(_, data), do: %Node{node: data}
end
