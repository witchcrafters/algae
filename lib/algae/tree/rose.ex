defmodule Algae.Tree.Rose do
  @type t :: %Algae.Tree.Rose{rose: any, tree: [Algae.Tree.Rose.t]}
  defstruct rose: nil, tree: [] # Remember that `nil` is a value, not bottom
end

defimpl Witchcraft.Functor, for: Algae.Tree.Rose do
  def lift(%Algae.Tree.Rose{rose: rose, tree: []}, fun) do
    %Algae.Tree.Rose{rose: Quark.Curry.curry(fun).(rose)}
  end

  def lift(%Algae.Tree.Rose{rose: rose, tree: tree}, fun) do
    %Algae.Tree.Rose{
      rose: Quark.Curry.curry(fun).(rose),
      tree: lift(tree, &(lift(&1, fun)))
    }
  end
end
