defmodule Algae.Tree.Rose do
  @moduledoc """
  A tree with any number of nodes at each level

  ## Examples

      %Algae.Tree.Rose{
        rose: 42,
        forrest: [
          %Algae.Tree.Rose{
            rose: "hi"
          },
          %Algae.Tree.Rose{
            forrest: [
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

  @doc """
  Create a simple `Algae.Rose` tree, with an empty forrest and one rose.

  ## Examples

      iex> new(42)
      %Algae.Tree.Rose{
        rose: 42,
        forrest: []
      }

  """
  @spec new(rose()) :: t()
  def new(rose), do: %Rose{rose: rose, forrest: []}

  @doc """
  Create an `Algae.Rose` tree, passing a forrest and a rose.

  ## Examples

      iex> new(42, [new(55), new(14)])
      %Algae.Tree.Rose{
        rose: 42,
        forrest: [
          %Algae.Tree.Rose{rose: 55},
          %Algae.Tree.Rose{rose: 14}
        ]
      }

  """
  @spec new(rose(), forrest()) :: t()
  def new(rose, forrest), do: %Rose{rose: rose, forrest: forrest}

  @doc """
  Wrap another tree around an existing one, relegating it to the forrest.

  ## Examples

      iex> 55
      ...> |> new()
      ...> |> layer(42)
      ...> |> layer(99)
      ...> |> layer(6)
      %Algae.Tree.Rose{
        rose: 6,
        forrest: [
          %Algae.Tree.Rose{
            rose: 99,
            forrest: [
              %Algae.Tree.Rose{
                rose: 42,
                forrest: [
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
  def layer(tree, rose), do: %Rose{rose: rose, forrest: [tree]}
end
