alias  Algae.Tree.Rose
alias  Witchcraft.Functor
import TypeClass

definst Witchcraft.Functor, for: Algae.Tree.Rose do
  def map(%Rose{rose: rose, forest: forest}, fun) do
    %Rose{
      rose:   fun.(rose),
      forest: Functor.map(forest, &Functor.map(&1, fun))
    }
  end
end
