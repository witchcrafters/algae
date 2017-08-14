alias  Algae.Tree.Rose
alias  Witchcraft.{Apply, Functor}
import TypeClass

definst Witchcraft.Apply, for: Algae.Tree.Rose do
  def convey(tree = %Rose{rose: rose, forrest: forrest}, %Rose{rose: fun, forrest: funs}) do
    new_forrest =
         Functor.map(forrest, &Functor.map(&1, fun))
      ++ Functor.map(funs,    &Apply.convey(tree, &1))

    %Rose{
      rose:    fun.(rose),
      forrest: new_forrest
    }
  end
end
