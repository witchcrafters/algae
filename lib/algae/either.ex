defmodule Algae.Either do
  use Quark.Partial

  @type t :: Left.t | Right.t # Type union

  defmodule Left do
    @type t :: %Left{left: any}
    defstruct [:left]
  end

  defmodule Right do
    @type t :: %Right{right: any}
    defstruct [:right]
  end

  defpartial left(value), do: %Left{left: value}
  defpartial right(value), do: %Right{right: value}

  def either(), do: &either/1
  def either(left: value), do: left(value)
  def either(right: value), do: right(value)
end
