alias  Algae.Tree.Rose
alias  Witchcraft.{Apply, Functor}
import TypeClass

definst Witchcraft.Apply, for: Algae.Tree.Rose do
  def convey(tree = %Rose{rose: rose, forest: forest}, %Rose{rose: fun, forest: funs}) do
    new_forest =
         Functor.map(forest, &Functor.map(&1, fun))
      ++ Functor.map(funs,   &Apply.convey(tree, &1))

    %Rose{
      rose:   fun.(rose),
      forest: new_forest
    }
  end
end
