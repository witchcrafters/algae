defmodule Algae.Maybe do
  use Quark.Partial

  @type t :: Just.t | Nothing.t

  defmodule Nothing do
    @type t :: %Nothing{}
    defstruct []
  end

  defmodule Just do
    @type t :: %Just{just: any}
    defstruct [:just]
  end

  def nothing(), do: %Algae.Maybe.Nothing{}
  defpartial just(value), do: %Algae.Maybe.Just{just: value}

  defdelegate maybe(), to: __MODULE__, as: :nothing
  defdelegate maybe(value), to: __MODULE__, as: :just
end

defimpl Witchcraft.Functor, for: Algae.Maybe.Just do
  import Quark.Curry, only: [curry: 1]

  def lift(%Algae.Maybe.Just{just: value}, fun) do
    Algae.Maybe.just curry(fun).(value)
  end
end

defimpl Witchcraft.Functor, for: Algae.Maybe.Nothing do
  def lift(_, _), do: Algae.Maybe.nothing
end
