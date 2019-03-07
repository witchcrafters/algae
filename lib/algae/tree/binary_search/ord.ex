alias Algae.Tree.BinarySearch.{Empty, Node}
import TypeClass
use Witchcraft

definst Witchcraft.Ord, for: Algae.Tree.BinarySearch.Empty do
  def compare(_, %Empty{}), do: :equal
  def compare(_, %Node{}),  do: :lesser
end

definst Witchcraft.Ord, for: Algae.Tree.BinarySearch.Node do
  custom_generator(_) do
    random_node()
  end

  def random_node do
    Enum.random([
      %Empty{},
      %Empty{},
      %Empty{},
      %Node{
        node: random_value()
      },
      %Node{
        node:  random_value(),
        left:  random_value(),
        right: random_value()
      }
    ])
  end

  def random_value, do: TypeClass.Property.Generator.generate(1)

  def compare(%Node{}, %Empty{}), do: :greater
  def compare(%Node{node: a}, %Node{node: b}), do: Witchcraft.Ord.compare(a, b)
end
