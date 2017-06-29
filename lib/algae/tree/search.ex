defmodule Algae.Tree.Search do
  @moduledoc """
  A binary search tree, with values at each node, and branches on either side
  """

  alias __MODULE__
  alias Quark.Curry, as: QC

  import Kernel, except: [node: 0]

  use Quark.Curry

  @type t :: Tip.t() | Node.t()

  defmodule Tip do
    @moduledoc "An empty node"

    @type t :: %Tip{}
    defstruct []
  end

  defmodule Node do
    @moduledoc "A node with a value and two offshoot branches to either side"

    @type t :: %Node{
      left:   Search.t(),
      middle: any(),
      right:  Search.t()
    }

    defstruct [:left, :middle, :right]
  end

  @spec tip() :: Search.Tip.t()
  def tip, do: %Search.Tip{}

  defcurry node(left, middle, right) do
    %Search.Node{
      left:   left,
      middle: middle,
      right:  right
    }
  end

  @spec node(left: Search.Node.t(), middle: any(), right: Search.Node.t())
     :: Search.Node.t()
  def node(left: left, middle: middle, right: right) do
    node(left, middle, right)
  end

  @spec node(Search.Node.t()) :: (any -> (Search.Node.t() -> Search.t()))
  def node(left), do: node().(left)

  @spec node(Search.Node.t(), any()) :: (Search.Node.t() -> Search.t())
  def node(left, middle), do: QC.uncurry(node(), [left, middle])

  @spec node(Search.Node.t(), any(), Search.Node.t()) :: Search.Node.t()
  def node(left, middle, right), do: QC.uncurry(node(), [left, middle, right])
end
