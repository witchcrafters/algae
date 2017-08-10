defmodule Algae.Tree.BinarySearch do
  @moduledoc """
  Represent a BinarySearch tree.
  Nodes may be empty, a leaf, or a branch (recursive subtree).

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

  def insert(%Empty{}, value), do: new(value)
  def insert(tree = %Node{node: node, left: left, right: right}, orderable) do
    case compare(orderable, node) do
      :equal   -> tree
      :greater -> %{tree | right: insert(right, orderable)}
      :lesser  -> %{tree | left:  insert(left,  orderable)}
    end
  end

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
          node:  32,
          left:  %Algae.Tree.BinarySearch.Empty{},
          right: %Algae.Tree.BinarySearch.Empty{}
        },
        right: %Algae.Tree.BinarySearch.Node{
          node: 77,
          left: %Algae.Tree.BinarySearch.Empty{},
          right: %Algae.Tree.BinarySearch.Node{
            node: 1234,
            left: %Algae.Tree.BinarySearch.Node{
              node:  98,
              left:  %Algae.Tree.BinarySearch.Empty{},
              right: %Algae.Tree.BinarySearch.Empty{}
            },
            right: %Algae.Tree.BinarySearch.Empty{}
          }
        }
      }

  """
  @spec from_list(list()) :: t()
  def from_list([]),            do: %Empty{}
  def from_list([head | tail]), do: from_list(tail, new(head))

  def from_list([],            seed), do: seed
  def from_list([head | tail], seed), do: from_list(tail, insert(seed, head))

  def sorted_from_list(list), do: list |> Enum.sort() |> from_list()

  def sorted_from_list(list, seed), do: list |> Enum.sort() |> from_list(seed)

  def balance(tree) do
    tree
    |> to_list()
    |> balanced_from_list()
  end

  def balanced_from_list([]), do: []
  def balanced_from_list(list) do
    list
    |> Enum.sort()
    |> balanced_from_list(new())
  end

  def balanced_from_list([],   seed), do: seed
  def balanced_from_list(list, seed) do
    center    = get_center(list, list)
    remaining = List.delete(center, list)

    seed
    |> insert(center)
    |> balanced_from_list(remaining)
  end

  def get_center([],               [head | _]),  do: head
  def get_center([_],              [head | _]),  do: head
  def get_center([_ | [_ | left]], [_ | right]), do: get_center(left, right)

end

alias Algae.Tree.BinarySearch.{Empty, Node}
import TypeClass
use Witchcraft

#############
# Generator #
#############

defimpl TypeClass.Property.Generator, for: Algae.Tree.BinarySearch.Empty do
  def generate(_), do: Empty.new()
end

defimpl TypeClass.Property.Generator, for: Algae.Tree.BinarySearch.Node do
  def generate(_) do
    random_node()
  end

  def random_node do
    case Enum.random(Enum.to_list(0..5)) do
      0 ->
        %Node{node: random_value()}

      1 ->
        %Node{node: random_value()}

      2 ->
        %Node{
          node:  random_value(),
          left:  random_node(),
          right: random_node()
        }

      _ ->
        %Empty{}
    end
  end

  def random_value do
    [1, 1.1, "", []]
    |> Enum.random()
    |> TypeClass.Property.Generator.generate()
  end
end

##########
# Setoid #
##########

definst Witchcraft.Setoid, for: Algae.Tree.BinarySearch.Empty do
  def equivalent?(_, %Empty{}), do: true
  def equivalent?(_, %Node{}),  do: false
end

definst Witchcraft.Setoid, for: Algae.Tree.BinarySearch.Node do
  def equivalent?(%Node{}, %Empty{}), do: false
  def equivalent?(%Node{node: a}, %Node{node: b}) do
    Witchcraft.Setoid.equivalent?(a, b)
  end
end

#######
# Ord #
#######

definst Witchcraft.Ord, for: Algae.Tree.BinarySearch.Empty do
  def compare(_, %Empty{}), do: :equal
  def compare(_, %Node{}),  do: :lesser
end

definst Witchcraft.Ord, for: Algae.Tree.BinarySearch.Node do
  custom_generator(_) do
    random_node()
  end

  def random_node do
    Enum.random([
      %Empty{},
      %Empty{},
      %Empty{},
      %Node{
        node: random_value()
      },
      %Node{
        node:  random_value(),
        left:  random_value(),
        right: random_value()
      }
    ])
  end

  def random_value, do: TypeClass.Property.Generator.generate(1)

  def compare(%Node{}, %Empty{}), do: :greater
  def compare(%Node{node: a}, %Node{node: b}), do: Witchcraft.Ord.compare(a, b)
end

# #############
# # Semigroup #
# #############

# definst Witchcraft.Semigroup, for: Algae.Tree.BinarySearch.Empty do
#   def append(_, right), do: right
# end

# definst Witchcraft.Semigroup, for: Algae.Maybe.Just do
#   custom_generator(_) do
#     1
#     |> TypeClass.Property.Generator.generate()
#     |> Just.new()
#   end

#   def append(%Just{just: a}, %Just{just: b}), do: %Just{just: a <> b}
#   def append(just, %Nothing{}), do: just
# end

# ##########
# # Monoid #
# ##########

# definst Witchcraft.Monoid, for: Algae.Tree.BinarySearch.Empty do
#   def empty(empty), do: empty
# end

# definst Witchcraft.Monoid, for: Algae.Tree.BinarySearch.Node do
#   def empty(_), do: %Empty{}
# end

###########
# Functor #
###########

definst Witchcraft.Functor, for: Algae.Tree.BinarySearch.Empty do
  def map(_, _), do: %Empty{}
end

definst Witchcraft.Functor, for: Algae.Tree.BinarySearch.Node do
  def map(%Node{node: node, left: left, right: right}, fun) do
    %Node{
      node:  fun.(node),
      left:  left ~> fun,
      right: right ~> fun
    }
  end
end

############
# Foldable #
############

definst Witchcraft.Foldable, for: Algae.Tree.BinarySearch.Empty do
  def right_fold(_, seed, _), do: seed
end

definst Witchcraft.Foldable, for: Algae.Tree.BinarySearch.Node do
  def right_fold(%Node{node: node, left: left, right: right}, seed, fun) do
    folded_right = Witchcraft.Foldable.right_fold(right, seed,         fun)
    folded_left  = Witchcraft.Foldable.right_fold(left,  folded_right, fun)

    fun.(node, folded_left)
  end
end

###############
# Traversable #
###############

# Not traversable because we don't have enough type information for Nothing

#########
# Apply #
#########

definst Witchcraft.Apply, for: Algae.Tree.BinarySearch.Empty do
  def convey(_, _), do: %Empty{}
end

definst Witchcraft.Apply, for: Algae.Tree.BinarySearch.Node do
  def convey(_, %Empty{}), do: %Empty{}
  def convey(%{node: node, left: left, right: right}, tree_funs = %Node{node: fun}) do
    %Node{
      node:  fun.(node),
      left:  Witchcraft.Apply.convey(left,  tree_funs),
      right: Witchcraft.Apply.convey(right, tree_funs)
    }
  end
end

###############
# Applicative #
###############

definst Witchcraft.Applicative, for: Algae.Tree.BinarySearch.Empty do
  def of(_, data), do: %Node{node: data}
end

definst Witchcraft.Applicative, for: Algae.Tree.BinarySearch.Node do
  @force_type_instance true
  def of(_, data), do: %Node{node: data}
end

#########
# Chain #
#########

definst Witchcraft.Chain, for: Algae.Tree.BinarySearch.Empty do
  def chain(_, _), do: %Empty{}
end

definst Witchcraft.Chain, for: Algae.Tree.BinarySearch.Node do
  def chain(%Node{node: node}, link), do: link.(node)
end

##########
# Extend #
##########

definst Witchcraft.Extend, for: Algae.Tree.BinarySearch.Empty do
  def nest(_), do: %Empty{}
end

definst Witchcraft.Extend, for: Algae.Tree.BinarySearch.Node do
  def nest(tree = %Node{left: left, right: right}) do
    %Node{
      node:  tree,
      left:  Witchcraft.Extend.nest(left),
      right: Witchcraft.Extend.nest(right)
    }
  end
end
