alias  Algae.Free.{Pure, Roll}
import Algae.Free

defimpl TypeClass.Property.Generator, for: Algae.Free.Pure do
  def generate(_) do
    [1, 1.1, "", []]
    |> Enum.random()
    |> TypeClass.Property.Generator.generate()
    |> Pure.new()
  end
end

defimpl TypeClass.Property.Generator, for: Algae.Free.Roll do
  def generate(_) do
    sample = Enum.random([1, 1.1, "", []])

    a = TypeClass.Property.Generator.generate(sample)
    b = TypeClass.Property.Generator.generate(sample)
    c = TypeClass.Property.Generator.generate(sample)

    a
    |> new()
    |> layer(new(b))
    |> layer(new(c))
  end
end
