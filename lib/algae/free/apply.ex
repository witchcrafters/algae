alias Algae.Free.{Pure, Roll}
alias Witchcraft.{Functor, Apply}

import TypeClass

definst Witchcraft.Apply, for: Algae.Free.Pure do
  def convey(%Pure{pure: data}, %Pure{pure: fun}), do: %Pure{pure: fun.(data)}

  def convey(pure, %Roll{roll: rolled}) do
    rolled
    |> Functor.map(&Apply.convey(pure, &1))
    |> Roll.new()
  end
end

definst Witchcraft.Apply, for: Algae.Free.Roll do
  def convey(%Roll{roll: rolled}, %Pure{pure: fun}) do
    rolled
    |> Functor.map(&Functor.map(&1, fun))
    |> Roll.new()
  end

  def convey(roll, %Roll{roll: rolled}) do
    rolled
    |> Functor.map(&Apply.convey(roll, &1))
    |> Roll.new()
  end
end
