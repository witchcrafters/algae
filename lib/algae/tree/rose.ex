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

  import Algae

  defdata do
    rose :: any()
    tree :: [t()]
  end
end
