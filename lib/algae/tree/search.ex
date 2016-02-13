defmodule Algae.Tree.Search do
  use Quark.Curry
  alias Quark.Curry, as: QC
  import Kernel, except: [node: 0]


  @type t :: Tip.t | Node.t

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

  defcurry node(left, middle, right) do
    %Algae.Tree.Search.Node{
      left: left,
      middle: middle,
      right: right
    }
  end

  @spec node(left: Algae.Tree.Search.Node.t, middle: any, right: Algae.Tree.Search.Node.t) :: Algae.Tree.Search.Node.t
  def node(left: left, middle: middle, right: right), do: node(left, middle, right)

  @spec node(Algae.Tree.Search.Node.t) :: (any -> (Algae.Tree.Search.Node.t -> Algae.Tree.Search.t))
  def node(left), do: node.(left)

  @spec node(Algae.Tree.Search.Node.t, any) :: (Algae.Tree.Search.Node.t -> Algae.Tree.Search.t)
  def node(left, middle), do: QC.uncurry(node, [left, middle])

  @spec node(Algae.Tree.Search.Node.t, any, Algae.Tree.Search.Node.t) :: Algae.Tree.Search.Node.t
  def node(left, middle, right), do: QC.uncurry(node, [left, middle, right])
end
