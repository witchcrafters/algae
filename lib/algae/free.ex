defmodule Algae.Free do
  use Quark.Partial

  @type t :: Algae.Free.Pure.t | Algae.Free.Deep.t

  defmodule Shallow do
    @type t :: %Algae.Free.Shallow{shallow: any}
    defstruct [:shallow]
  end

  defmodule Deep do
    @moduledoc ~S"""
    Deep holds two values: a value (often a functor) in `deep`, and another
    `Algae.Free.t` in `deeper`.

    ```elixir

    %Free.Deep{deep: %Id{id: 42}, deeper: %Free.Shallow{shallow: "Terminus"}}

    ```

    """

    @type t :: %Algae.Free.Deep{deep: any, deeper: Algae.Free.t}

    defstruct [:deep, :deeper]
  end

  @spec deep() :: (Algae.Free.Deep.t -> (any -> Algae.Free.Deep.t))
  @spec deep(Algae.Free.Deep.t) :: (any -> Algae.Free.Deep.t)
  @spec deep(Algae.Free.Deep.t, any) :: Algae.Free.Deep.t

  defpartial deep(%Algae.Free.Deep{deep: deep, deeper: deeper}, value) do
    %Algae.Free.Deep{deep: value, deeper: %Algae.Free.Deep{deep: deep, deeper: deeper}}
  end

  @spec shallow() :: (any -> Algae.Free.Shallow.t)
  @spec shallow(any) :: Algae.Free.Shallow.t

  defpartial shallow(value), do: %Algae.Free.Shallow{shallow: value}
end
