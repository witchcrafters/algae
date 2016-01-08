defmodule Algae.Writer do
  @type t :: %Algae.Writer{writer: Witchcraft.Monad.t, env: Witchcraft.Monoid.t}
  defstruct writer: &append/2, env: []

  @spec append(any, list) :: list
  defp append(new, acc), do: [new|acc]

  def write(%Algae.Writer{writer: writer, env: env}) do
    Quark.Curry.curry(writer).(env)
  end

  # def tell()
  # def listen()
  # def pass()
  # def censor
end

defimpl Witchcraft.Functor, for: Algae.Writer do
  def lift(%Algae.Writer{writer: writer, env: env}, fun) do
    import Quark.Compose, only: [<|>: 2]
    %Algae.Writer{writer: fun <|> writer, env: env}
  end
end
