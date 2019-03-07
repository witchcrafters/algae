defmodule Algae.Tree.BinarySearch do
  @moduledoc """
  Represent a `BinarySearch` tree.

  ## Examples

      iex> alias Algae.Tree.BinarySearch, as: BSTree
      ...>
      ...> BSTree.Node.new(
      ...>   42,
      ...>   BSTree.Node.new(77),
      ...>   BSTree.Node.new(
      ...>     1234,
      ...>     BSTree.Node.new(98),
      ...>     BSTree.Node.new(32)
      ...>   )
      ...> )
      %Algae.Tree.BinarySearch.Node{
        node: 42,
        left: %Algae.Tree.BinarySearch.Node{
          node:  77,
          left:  %Algae.Tree.BinarySearch.Empty{},
          right: %Algae.Tree.BinarySearch.Empty{}
        },
        right: %Algae.Tree.BinarySearch.Node{
          node:  1234,
          left:  %Algae.Tree.BinarySearch.Node{
            node:  98,
            left:  %Algae.Tree.BinarySearch.Empty{},
            right: %Algae.Tree.BinarySearch.Empty{}
          },
          right: %Algae.Tree.BinarySearch.Node{
            node:  32,
            left:  %Algae.Tree.BinarySearch.Empty{},
            right: %Algae.Tree.BinarySearch.Empty{}
          }
        }
      }

  """

  alias __MODULE__
  import Algae
  use Witchcraft, except: [to_list: 1]

  defsum do
    defdata Empty :: none()

    defdata Node do
      node :: any()
      left  :: BinarySearch.t() \\ Empty.new()
      right :: BinarySearch.t() \\ Empty.new()
    end
  end

  @doc """
  Create an empty tree.

  ## Examples

      iex> new()
      %Algae.Tree.BinarySearch.Empty{}

  """
  @spec new() :: Empty.t()
  def new, do: %Empty{}

  @doc """
  Bring a value into an otherwise empty tree.

  ## Examples

      iex> new(42)
      %Algae.Tree.BinarySearch.Node{
        node:  42,
        left:  %Algae.Tree.BinarySearch.Empty{},
        right: %Algae.Tree.BinarySearch.Empty{}
      }

  """
  @spec new(any()) :: Node.t()
  def new(value), do: %Node{node: value}

  @doc """
  Insert a new element into a tree.

  ## Examples

      iex> insert(new(42), 43)
      %Algae.Tree.BinarySearch.Node{
        node: 42,
        right: %Algae.Tree.BinarySearch.Node{
          node: 43
        }
      }

  """
  @spec insert(t(), any()) :: t()
  def insert(%Empty{}, value), do: new(value)
  def insert(tree = %Node{node: node, left: left, right: right}, orderable) do
    case compare(orderable, node) do
      :equal   -> tree
      :greater -> %{tree | right: insert(right, orderable)}
      :lesser  -> %{tree | left:  insert(left,  orderable)}
    end
  end

  def insert(%Empty{}, value), do: new(value)
  def insert(tree = %Node{node: node, left: left, right: right}, orderable) do
    case compare(orderable, node) do
      :equal   -> tree
      :greater -> %{tree | right: insert(right, orderable)}
      :lesser  -> %{tree | left:  insert(left,  orderable)}
    end
  end

  @doc """
  Remove an element from a tree by value.

  ## Examples

      iex> alias Algae.Tree.BinarySearch, as: BSTree
      ...>
      ...> BSTree.Node.new(
      ...>   42,
      ...>   BSTree.Node.new(77),
      ...>   BSTree.Node.new(
      ...>     1234,
      ...>     BSTree.Node.new(98),
      ...>     BSTree.Node.new(32)
      ...>   )
      ...> ) |> delete(98)
      %Algae.Tree.BinarySearch.Node{
        node: 42,
        left: %Algae.Tree.BinarySearch.Node{
          node: 77
        },
        right: %Algae.Tree.BinarySearch.Node{
          node: 1234,
          right: %Algae.Tree.BinarySearch.Node{
            node: 32
          }
        }
      }

  """
  @spec delete(t(), any()) :: t()
  def delete(%Empty{}, _), do: %Empty{}
  def delete(tree = %Node{node: node, left: left, right: right}, orderable) do
    case compare(orderable, node) do
      :greater ->
        %{tree | right: delete(right, orderable)}

      :lesser ->
        %{tree | left:  delete(left, orderable)}

      :equal ->
        case tree do
          %{left:  %Empty{}}       -> right
          %{right: %Empty{}}       -> left
          %{right: %{node: shift}} -> %{tree | node: shift, right: delete(right, shift)}
        end
    end
  end

  @doc """
  Flatten a tree into a list.

  ## Examples

      iex> alias Algae.Tree.BinarySearch, as: BSTree
      ...>
      ...> BSTree.Node.new(
      ...>   42,
      ...>   BSTree.Node.new(77),
      ...>   BSTree.Node.new(
      ...>     1234,
      ...>     BSTree.Node.new(98),
      ...>     BSTree.Node.new(32)
      ...>   )
      ...> )
      ...> |> BSTree.to_list()
      [42, 77, 1234, 98, 32]

  """
  @spec to_list(t()) :: list()
  def to_list(tree), do: Witchcraft.Foldable.to_list(tree)

  @doc """
  Flatten a tree into a list with elements sorted.

  ## Examples

      iex> alias Algae.Tree.BinarySearch, as: BSTree
      ...>
      ...> BSTree.Node.new(
      ...>   42,
      ...>   BSTree.Node.new(77),
      ...>   BSTree.Node.new(
      ...>     1234,
      ...>     BSTree.Node.new(98),
      ...>     BSTree.Node.new(32)
      ...>   )
      ...> )
      ...> |> BSTree.to_ordered_list()
      [32, 42, 77, 98, 1234]

  """
  @spec to_ordered_list(t()) :: list()
  def to_ordered_list(tree), do: tree |> to_list() |> Enum.sort()

  @doc """
  Build a `BinarySearch` tree from a list.

  ## Examples

      iex> Algae.Tree.BinarySearch.from_list([42, 77, 1234, 98, 32])
      %Algae.Tree.BinarySearch.Node{
        node: 42,
        left: %Algae.Tree.BinarySearch.Node{
          node:  32
        },
        right: %Algae.Tree.BinarySearch.Node{
          node: 77,
          right: %Algae.Tree.BinarySearch.Node{
            node: 1234,
            left: %Algae.Tree.BinarySearch.Node{
              node:  98
            }
          }
        }
      }

  """
  @spec from_list(list()) :: t()
  def from_list([]),            do: %Empty{}
  def from_list([head | tail]), do: from_list(tail, new(head))

  @doc """
  Build a `BinarySearch` tree from a list and attach to an existing tree.

  ## Examples

      iex> Algae.Tree.BinarySearch.from_list([42, 77, 1234, 98, 32], new(-9))
      %Algae.Tree.BinarySearch.Node{
        node:  -9,
        right: %Algae.Tree.BinarySearch.Node{
          left: %Algae.Tree.BinarySearch.Node{
            node:  32
          },
          node: 42,
          right: %Algae.Tree.BinarySearch.Node{
            node: 77,
            right: %Algae.Tree.BinarySearch.Node{
              node: 1234,
              left: %Algae.Tree.BinarySearch.Node{
                node: 98
              },
              right: %Algae.Tree.BinarySearch.Empty{}
            }
          }
        }
      }

  """
  @spec from_list(list(), t()) :: t()
  def from_list([],            seed), do: seed
  def from_list([head | tail], seed), do: from_list(tail, insert(seed, head))

end
