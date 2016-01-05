defmodule Algae.Tree.Search do
  @type t :: Tip.t | Node.t
  # data Stree a = Tip | Node (Stree a) a (Stree a)

  defmodule Tip do
    @type t :: %Tip{}
    defstruct []
  end

  defmodule Node do
    @type t :: %Node{left: Algae.Tree.Search.t, middle: any, right: Algae.Tree.Search.t}
    defstruct [:left, :middle, :right]
  end

  @spec tip() :: Algae.Tree.Search.Tip.t
  def tip(), do: %Algae.Tree.Search.Tip{}

  @spec node(Algae.Tree.Search.Node.t, any, Algae.Tree.Search.Node.t) :: ALgae.Tree.Search.Node.t
  def node(left, middle, right) do
    %Algae.Tree.Search.Node{
      left: left,
      middle: middle,
      right: right
    }
  end

  @spec node(Algae.Tree.Search.Node.t, any, Algae.Tree.Search.Node.t) :: Algae.Tree.Search.Node.t
  def node(left: left, middle: middle, right: right), do: node(left, middle, right)
end

defimpl Witchcraft.Functor, for: Algae.Tree.Search.Tip do
  def lift(%Algae.Tree.Search.Tip{}, _), do: %Algae.Tree.Search.Tip{}
end

defimpl Witchcraft.Functor, for: Algae.Tree.Search.Node do
  import Witchcraft.Functor.Functions, only: [<~: 2]

  def lift(%Algae.Tree.Search.Node{left: left, middle: middle, right: right}, fun) do
    %Algae.Tree.Search.Node{
      left: left <~ &lift(&1, fun),
      middle: middle <~ fun,
      right: right <~ &lift(&1, fun)
    }
  end
end
