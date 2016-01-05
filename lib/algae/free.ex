defmodule Algae.Free do
  use Quark.Partial

  @type t :: Algae.Free.Pure.t | Algae.Free.Wrap.t

  defmodule Pure do
    @type t :: %Algae.Free.Pure{pure: any}
    defstruct [:pure]
  end

  defmodule Wrap do
    @type t :: %Algae.Free.Wrap{wrap: any}
    defstruct [:wrap]
  end

  @spec wrap(any) :: Algae.Free.Wrap.t
  defpartial wrap(value), do: %Algae.Free.Wrap{wrap: value}
end

defimpl Witchcraft.Functor, for: Algae.Free.Pure do
  def lift(%Algae.Free.Pure{pure: pure}, fun), do: Quark.Curry.curry(fun).(pure)
end

defimpl Witchcraft.Functor, for: Algae.Free.Wrap do
  import Quark.Curry, only: [curry: 1]
  import Witchcraft.Functor.Functions, only: [~>: 2]

  def lift(%Algae.Free.Wrap{wrap: wrap}, fun) do
    # TODO Update &lift(&1, curry func) when Witchcraft has lift/1 (in the Applicative branch)
    %Algae.Free.Wrap{wrap: &lift(&1, curry fun) ~> wrap}
  end
end
