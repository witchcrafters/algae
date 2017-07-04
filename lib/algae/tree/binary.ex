defmodule Algae.Tree.Binary do
  @moduledoc """
  Represent a binary tree.
  Nodes may be empty, a leaf, or a branch (recursive subtree).

  ## Examples

      %Algae.Tree.Branch{
        left:  %Algae.Tree.Empty{},
        right: %Algae.Tree.Leaf{leaf: 42}
      }

  """

  alias __MODULE__
  import Algae

  defsum do
    defdata Empty :: none()

    defdata Branch do
      value :: any()
      left  :: Binary.t() \\ Binary.Empty.t()
      right :: Binary.t() \\ Binary.Empty.t()
    end
  end
end
