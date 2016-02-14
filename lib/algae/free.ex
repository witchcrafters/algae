defmodule Algae.Free do
  use Quark.Partial

  @type t :: Algae.Free.Pure.t | Algae.Free.Wrap.t

  defmodule Pure do
    @type t :: %Algae.Free.Pure{pure: any}
    defstruct [:pure]
  end

  defmodule Wrap do
    @type t :: %Algae.Free.Wrap{wrap: any}

    @moduledoc ~S"""
    `wrap` must be some functor wrapping another `%Free.X{}`

    ```elixir

    %Free.Wrap{wrap: %Id{id: %Free.Pure{pure: "Terminus"}}

    ```

    """
    defstruct [:wrap]
  end

  @spec wrap(any) :: Algae.Free.Wrap.t
  defpartial wrap(value), do: %Algae.Free.Wrap{wrap: value}
end
