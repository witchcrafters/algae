defmodule Algae.Either do
  use Quark.Partial

  @type t :: Left.t | Right.t # Type union

  defmodule Left do
    @type t :: %Left{left: any}
    defstruct [:left]
  end

  defmodule Right do
    @type t :: %Left{left: any}
    defstruct [:right]
  end

  defpartial left(value), do: %Left{left: value}
  defpartial right(value), do: %Right{right: value}

  def either(), do: &either/1
  def either(left: value), do: left(value)
  def either(right: value), do: right(value)
end

defimpl Witchcraft.Functor, for: Algae.Either.Left do
  def lift(%Algae.Either.Left{left: value}, fun) do
    Algae.Either.left Quark.Curry.curry(fun).(value)
  end
end

defimpl Witchcraft.Functor, for: Algae.Either.Right do
  def lift(%Algae.Either.Right{right: value}, fun) do
    Algae.Either.right Quark.Curry.curry(fun).(value)
  end
end
