alias Algae.Tree.BinarySearch.{Empty, Node}
use Witchcraft

defimpl TypeClass.Property.Generator, for: Algae.Tree.BinarySearch.Empty do
  def generate(_), do: Empty.new()
end

defimpl TypeClass.Property.Generator, for: Algae.Tree.BinarySearch.Node do
  def generate(_) do
    random_node()
  end

  def random_node do
    case Enum.random(Enum.to_list(0..5)) do
      0 ->
        %Node{node: random_value()}

      1 ->
        %Node{node: random_value()}

      2 ->
        %Node{
          node:  random_value(),
          left:  random_node(),
          right: random_node()
    }

      _ ->
        %Empty{}
    end
  end

  def random_value do
    [1, 1.1, "", []]
    |> Enum.random()
    |> TypeClass.Property.Generator.generate()
  end
end
