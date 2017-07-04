defmodule Algae.Tree.Rose do
  @moduledoc """
  A tree with any number of nodes at each level

  ## Examples

      %Algae.Tree.Rose{
        rose: 42,
        tree: [
          %Algae.Tree.Rose{
            rose: "hi"
          },
          %Algae.Tree.Rose{
            tree: [
              %Algae.Tree.Rose{
                rose: 0.4
              }
            ]
          },
          %Algae.Tree.Rose{
            rose: "there"
          }
        ]
      }

  """

  alias __MODULE__
  # use Quark.Curry
  import Algae

  # @type t :: %Rose{rose: any(), tree: [Rose.t()]}

  defdata do
    rose :: any()
    tree :: [t()]
  end

  # defstruct rose: nil, tree: [] # Remember that `nil` is a value, not bottom

  # @spec rose() :: (any() -> ([Rose.t()] -> Rose.t()))
  # defcurry rose(r, t), do: rose(r, t)

  # @spec rose(any(), [Rose.t()]) :: Rose.t()
  # def rose(rose: r, tree: t), do: rose(r, t)

  # @spec rose(any()) :: ([Rose.t()] -> Rose.t())
  # def rose(r), do: rose.(r)

  # @spec rose(any(), [Rose.t()]) :: Rose.t()
  # def rose(r, t), do: %Rose{rose: r, tree: t}
end
