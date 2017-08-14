alias  Algae.Tree.Rose
alias  Witchcraft.{Chain, Functor}
import TypeClass

definst Witchcraft.Chain, for: Algae.Tree.Rose do
  def chain(%Rose{rose: rose, forrest: forrest}, link) do
    %Rose{rose: new_rose, forrest: mid_forrest} = link.(rose)

    new_forrest = mid_forrest ++ Functor.map(forrest, &Chain.chain(&1, link))

    Rose.new(new_rose, new_forrest)
  end
end
