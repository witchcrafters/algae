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

  import Algae

  defsum do
    defdata Empty :: none()
    defdata Leaf  :: any()

    defdata Branch do
      left  :: any()
      right :: any()
    end
  end
end
