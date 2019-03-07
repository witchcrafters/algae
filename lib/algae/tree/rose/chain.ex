alias  Algae.Tree.Rose
alias  Witchcraft.{Chain, Functor}
import TypeClass

definst Witchcraft.Chain, for: Algae.Tree.Rose do
  def chain(%Rose{rose: rose, forest: forest}, link) do
    %Rose{rose: new_rose, forest: mid_forest} = link.(rose)

    new_forest = mid_forest ++ Functor.map(forest, &Chain.chain(&1, link))

    Rose.new(new_rose, new_forest)
  end
end
