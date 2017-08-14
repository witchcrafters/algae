alias  Algae.Free.Pure
alias  TypeClass.Property.Generator

import Algae.Free

defimpl TypeClass.Property.Generator, for: Algae.Free.Pure do
  def generate(_) do
    [1, 1.1, "", []]
    |> Enum.random()
    |> Generator.generate()
    |> Pure.new()
  end
end

defimpl TypeClass.Property.Generator, for: Algae.Free.Roll do
  def generate(_) do
    inner = Algae.Id.new()

    seed =
      [1, 1.1, "", []]
      |> Enum.random()
      |> Generator.generate()

    seed
    |> new()
    |> layer(inner)
    |> layer(inner)
  end
end
