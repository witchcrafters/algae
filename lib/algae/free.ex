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

  @spec wrap(any) :: Algae.Free.Wrap.t
  defpartial wrap(value), do: %Algae.Free.Wrap{wrap: value}
end
