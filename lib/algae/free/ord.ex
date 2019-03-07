alias  Algae.Free.{Pure, Roll}
alias  Witchcraft.Ord
alias  TypeClass.Property.Generator

import Algae.Free
import TypeClass

definst Witchcraft.Ord, for: Algae.Free.Pure do
  custom_generator(_) do
    1
    |> TypeClass.Property.Generator.generate()
    |> Algae.Free.new()
  end

  def compare(_, %Roll{}), do: :lesser
  def compare(%Pure{pure: a}, %Pure{pure: b}), do: Ord.compare(a, b)
end

definst Witchcraft.Ord, for: Algae.Free.Roll do
  custom_generator(_) do
    inner = Algae.Id.new()
    seed  = Generator.generate(1)

    seed
    |> new()
    |> layer(inner)
    |> layer(inner)
  end

  def compare(%Roll{}, %Pure{}), do: :greater
  def compare(%Roll{roll: a}, %Roll{roll: b}), do: Ord.compare(a, b)
end
