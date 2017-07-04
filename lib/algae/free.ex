defmodule Algae.Free do
  @moduledoc """
  A "free" structure, similar to lists

  ## Shallow
  `Shallow` holds a plain value

  ## Deep

  `Deep` holds two values: a value (often a functor) in `deep`, and another
  `Algae.Free.t` in `deeper`

      %Free.Deep{
        deep:   %Id{id: 42},
        deeper: %Free.Shallow{shallow: "Terminus"}
      }

  """

  import Algae

  defsum do
    defdata Shallow :: any()

    defdata Deep do
      deep   :: any()
      deeper :: any()
    end
  end
end
