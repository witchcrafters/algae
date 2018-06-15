import TypeClass
use Witchcraft

definst Witchcraft.Monad, for: Algae.Tree.BinarySearch.Empty

definst Witchcraft.Monad, for: Algae.Tree.BinarySearch.Node do
  @force_type_instance true
end
