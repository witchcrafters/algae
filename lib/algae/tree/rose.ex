defmodule Algae.Tree.Rose do
  use Quark.Curry

  @type t :: %Algae.Tree.Rose{rose: any, tree: [Algae.Tree.Rose.t]}

  defstruct rose: nil, tree: [] # Remember that `nil` is a value, not bottom

  @spec rose() :: (any -> ([Algae.Tree.Rose.t] -> Algae.Tree.Rose.t))
  defcurry rose(r, t), do: rose(r, t)

  @spec rose(any, [Algae.Tree.Rose.t]) :: Algae.Tree.Rose.t
  def rose(rose: r, tree: t), do: rose(r, t)

  @spec rose(any) :: ([Algae.Tree.Rose.t] -> Algae.Tree.Rose.t)
  def rose(r), do: rose.(r)

  @spec rose(any, [Algae.Tree.Rose.t]) :: Algae.Tree.Rose.t
  def rose(r, t), do: %Algae.Tree.Rose{rose: r, tree: t}
end
