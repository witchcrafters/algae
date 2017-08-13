alias  Algae.Free.{Pure, Roll}
alias  Witchcraft.{Functor, Apply}

import Algae.Free
import TypeClass

definst Witchcraft.Apply, for: Algae.Free.Pure do
  def convey(%Pure{pure: data}, %Pure{pure: fun}), do: %Pure{pure: fun.(data)}

  def convey(pure, %Roll{roll: roll}) do
    roll
    |> Functor.map(&Apply.convey(pure, &1))
    |> Roll.new()
  end
end

definst Witchcraft.Apply, for: Algae.Free.Roll do
  def convey(%Roll{roll: roll}, %Pure{pure: fun}) do
    roll
    |> Functor.map(&Functor.map(&1, fun))
    |> Roll.new()
  end

  def convey(roll, %Roll{roll: inner}) do
    inner
    |> Functor.map(&Apply.convey(roll, &1))
    |> Roll.new()
  end
end
