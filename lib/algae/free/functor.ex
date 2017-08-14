alias Algae.Free.{Pure, Roll}
alias Witchcraft.Functor

import TypeClass

definst Witchcraft.Functor, for: Algae.Free.Pure do
  def map(%Pure{pure: data}, fun), do: %Pure{pure: fun.(data)}
end

definst Witchcraft.Functor, for: Algae.Free.Roll do
  def map(%Roll{roll: data}, fun) do
    data
    |> Functor.map(&Functor.map(&1, fun))
    |> Roll.new()
  end
end
