alias Algae.Tree.BinarySearch.Node
import TypeClass
use Witchcraft

definst Witchcraft.Foldable, for: Algae.Tree.BinarySearch.Empty do
  def right_fold(_, seed, _), do: seed
end

definst Witchcraft.Foldable, for: Algae.Tree.BinarySearch.Node do
  def right_fold(%Node{node: node, left: left, right: right}, seed, fun) do
    folded_right = Witchcraft.Foldable.right_fold(right, seed,         fun)
    folded_left  = Witchcraft.Foldable.right_fold(left,  folded_right, fun)

    fun.(node, folded_left)
  end
end
