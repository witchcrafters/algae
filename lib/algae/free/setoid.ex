alias  Algae.Free.{Pure, Roll}
alias  Witchcraft.Setoid

import Algae.Free
import TypeClass

definst Witchcraft.Setoid, for: Algae.Free.Pure do
  custom_generator(_) do
    1
    |> TypeClass.Property.Generator.generate()
    |> Algae.Free.new()
  end

  def equivalent?(_, %Roll{}), do: false
  def equivalent?(%Pure{pure: a}, %Pure{pure: b}), do: Setoid.equivalent?(a, b)
end

definst Witchcraft.Setoid, for: Algae.Free.Roll do
  custom_generator(_) do
    a = TypeClass.Property.Generator.generate(1)
    b = TypeClass.Property.Generator.generate(1)
    c = TypeClass.Property.Generator.generate(1)

    a
    |> new()
    |> layer(new(b))
    |> layer(new(c))
  end

  def equivalent?(_, %Pure{}), do: false
  def equivalent?(%Roll{roll: a}, %Roll{roll: b}), do: Setoid.equivalent?(a, b)
end
