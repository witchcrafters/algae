alias  Algae.Free.{Pure, Roll}
alias  Witchcraft.Setoid
alias  TypeClass.Property.Generator

import Algae.Free
import TypeClass

definst Witchcraft.Setoid, for: Algae.Free.Pure do
  custom_generator(_) do
    1
    |> Generator.generate()
    |> Pure.new()
  end

  def equivalent?(_, %Roll{}), do: false
  def equivalent?(%Pure{pure: a}, %Pure{pure: b}), do: Setoid.equivalent?(a, b)
end

definst Witchcraft.Setoid, for: Algae.Free.Roll do
  custom_generator(_) do
    inner = Algae.Id.new()
    seed  = Generator.generate(1)

    seed
    |> new()
    |> layer(inner)
    |> layer(inner)
  end

  def equivalent?(_, %Pure{}), do: false
  def equivalent?(%Roll{roll: a}, %Roll{roll: b}), do: Setoid.equivalent?(a, b)
end
