alias  Algae.Tree.Rose
alias  Witchcraft.Functor
import TypeClass

definst Witchcraft.Functor, for: Algae.Tree.Rose do
  def map(%Rose{rose: rose, forrest: forrest}, fun) do
    %Rose{
      rose:    fun.(rose),
      forrest: Functor.map(forrest, &Functor.map(&1, fun))
    }
  end
end
