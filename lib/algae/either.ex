defmodule Algae.Either do
  @type t :: Left.t | Right.t # Type union

  defmodule Left do
    @type t :: %Left{left: any}
    defstruct [:left]
  end

  defmodule Right do
    @type t :: %Left{left: any}
    defstruct [:right]
  end

  def left(value), do: %Left{left: value}
  def right(value), do: %Right{right: value}

  def either(left: value), do: left(value)
  def either(right: value), do: right(value)
end

defimpl Witchcraft.Functor, for: Algae.Either.Left do
  import Quark.Curry, only: [curry: 1]

  def lift(%Algae.Either.Left{left: value}, fun) do
    Algae.Either.left curry(fun).(value)
  end
end

defimpl Witchcraft.Functor, for: Algae.Either.Right do
  import Quark.Curry, only: [curry: 1]

  def lift(%Algae.Either.Right{right: value}, fun) do
    Algae.Either.right curry(fun).(value)
  end
end
