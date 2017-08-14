alias Algae.Free.{Pure, Roll}
alias Witchcraft.{Functor, Chain}

import TypeClass

definst Witchcraft.Chain, for: Algae.Free.Pure do
  def chain(%Pure{pure: pure}, link), do: link.(pure)
end

definst Witchcraft.Chain, for: Algae.Free.Roll do
  def chain(%Roll{roll: rolled}, link) do
    rolled
    |> Functor.map(&Chain.chain(&1, link))
    |> Roll.new()
  end
end
