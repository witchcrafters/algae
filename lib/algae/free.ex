defmodule Algae.Free do
  @moduledoc """
  A "free" structure. Similar to lists.

  * `Shallow` holds a plain value
  * `Deep` holds recursive `Free` structs
  """

  use Quark.Partial
  alias __MODULE__

  @type t :: Free.Shallow.t() | Free.Deep.t()

  defmodule Shallow do
    @moduledoc "Hold a simple value"

    @type t :: %Free.Shallow{shallow: any}
    defstruct [:shallow]

    @spec new(any()) :: Free.Shallow.t()
    def new(value), do: %Free.Shallow{shallow: value}
  end

  defmodule Deep do
    @moduledoc ~S"""
    Deep holds two values: a value (often a functor) in `deep`, and another
    `Algae.Free.t` in `deeper`.

    %Free.Deep{
      deep:   %Id{id: 42},
      deeper: %Free.Shallow{shallow: "Terminus"}
    }

    """

    @type t :: %Free.Deep{deep: any, deeper: Free.t()}

    defstruct [:deep, :deeper]
  end

  @spec deep() :: (Free.Deep.t() -> (any() -> Free.Deep.t()))
  @spec deep(Free.Deep.t()) :: (any() -> Free.Deep.t())
  @spec deep(Free.Deep.t(), any()) :: Free.Deep.t()

  defpartial deep(%Free.Deep{deep: deep, deeper: deeper}, value) do
    %Free.Deep{
      deep: value,
      deeper: %Free.Deep{
        deep:   deep,
        deeper: deeper
      }
    }
  end

  @spec shallow() :: (any() -> Free.Shallow.t())
  @spec shallow(any()) :: Free.Shallow.t()

  defpartial shallow(value), do: %Free.Shallow{shallow: value}
end
