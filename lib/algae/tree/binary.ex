defmodule Algae.Tree.Binary do
  @moduledoc """
  Represent a binary tree.
  Nodes may be empty, a leaf, or a branch (recursive subtree).

  ## Examples

      iex> alias Algae.Tree.Binary, as: BTree
      ...>
      ...> BTree.Branch.new(
      ...>   42,
      ...>   BTree.Branch.new(77),
      ...>   BTree.Branch.new(
      ...>     1234,
      ...>     BTree.Branch.new(98),
      ...>     BTree.Branch.new(32)
      ...>   )
      ...> )
      %Algae.Tree.Binary.Branch{
        value: 42,
        left: %Algae.Tree.Binary.Branch{
          value: 77,
          left:  %Algae.Tree.Binary.Empty{},
          right: %Algae.Tree.Binary.Empty{}
        },
        right: %Algae.Tree.Binary.Branch{
          value: 1234,
          left:  %Algae.Tree.Binary.Branch{
            value: 98,
            left:  %Algae.Tree.Binary.Empty{},
            right: %Algae.Tree.Binary.Empty{}
          },
          right: %Algae.Tree.Binary.Branch{
            value: 32,
            left:  %Algae.Tree.Binary.Empty{},
            right: %Algae.Tree.Binary.Empty{}
          }
        }
      }

  """

  alias __MODULE__

  import Algae

  defsum do
    defdata Empty :: none()

    defdata Branch do
      value :: any()
      left  :: Binary.t() \\ Empty.new()
      right :: Binary.t() \\ Empty.new()
    end
  end
end
