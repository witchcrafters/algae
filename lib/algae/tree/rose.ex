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

  alias  __MODULE__
  import Algae

  @type rose :: any()
  @type forrest :: [t()]

  defdata do
    rose    :: any()
    forrest :: [t()]
  end

  def new(rose), do: %Rose{rose: rose, forrest: []}

  def new(rose, forrest), do: %Rose{rose: rose, forrest: forrest}

  def layer(tree, rose), do: %Rose{rose: rose, forrest: [tree]}
end
