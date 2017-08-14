defmodule Algae.Tree.Rose do
  @moduledoc """
  A tree with any number of nodes at each level

  ## Examples

      %Algae.Tree.Rose{
        rose: 42,
        forest: [
          %Algae.Tree.Rose{
            rose: "hi"
          },
          %Algae.Tree.Rose{
            forest: [
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
  @type forest :: [t()]

  defdata do
    rose    :: any()
    forest :: [t()]
  end

  @doc """
  Create a simple `Algae.Rose` tree, with an empty forest and one rose.

  ## Examples

      iex> new(42)
      %Algae.Tree.Rose{
        rose: 42,
        forest: []
      }

  """
  @spec new(rose()) :: t()
  def new(rose), do: %Rose{rose: rose, forest: []}

  @doc """
  Create an `Algae.Rose` tree, passing a forest and a rose.

  ## Examples

      iex> new(42, [new(55), new(14)])
      %Algae.Tree.Rose{
        rose: 42,
        forest: [
          %Algae.Tree.Rose{rose: 55},
          %Algae.Tree.Rose{rose: 14}
        ]
      }

  """
  @spec new(rose(), forest()) :: t()
  def new(rose, forest), do: %Rose{rose: rose, forest: forest}

  @doc """
  Wrap another tree around an existing one, relegating it to the forest.

  ## Examples

      iex> 55
      ...> |> new()
      ...> |> layer(42)
      ...> |> layer(99)
      ...> |> layer(6)
      %Algae.Tree.Rose{
        rose: 6,
        forest: [
          %Algae.Tree.Rose{
            rose: 99,
            forest: [
              %Algae.Tree.Rose{
                rose: 42,
                forest: [
                  %Algae.Tree.Rose{
                    rose: 55
                  }
                ]
              }
            ]
          }
        ]
      }

  """
  @spec layer(t(), rose()) :: t()
  def layer(tree, rose), do: %Rose{rose: rose, forest: [tree]}
end
