alias  Algae.Tree.Rose
alias  TypeClass.Property.Generator

defimpl TypeClass.Property.Generator, for: Algae.Tree.Rose do
  def generate(_) do
    case Enum.random(0..2) do
      0 -> Rose.new(rose(), forest())
      _ -> Rose.new(rose())
    end
  end

  def forest do
    fn ->
      case Enum.random(0..10) do
        0 -> Rose.new(rose(), forest())
        _ -> Rose.new(rose())
      end
    end
    |> Stream.repeatedly()
    |> Enum.take(Enum.random(0..5))
  end

  def rose do
    [1, 1.1, "", []]
    |> Enum.random()
    |> Generator.generate()
  end
end
