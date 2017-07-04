defmodule Algae.Tree.Search do
  @moduledoc """
  A binary search tree, with values at each node, and branches on either side
  """

  alias __MODULE__

  import Algae

  defsum do
    defdata Tip :: none()

    defdata Node do
      left   :: Search.t()
      middle :: any()
      right  :: Search.t()
    end
  end
end
