defmodule Algae.Reader do
  @moduledoc ~S"""
  `Algae.Reader` allows you to pass some readable context around through actions.

  This is useful in a number of situations, but the most common case is to weave
  access to environment variables monadically.

  For an illustrated guide to `Reader`s,
  see [Thee Useful Monads](http://adit.io/posts/2013-06-10-three-useful-monads.html#the-state-monad).

  ## Examples

      iex> use Witchcraft
      ...>
      ...> correct =
      ...>   monad %Algae.Reader{} do
      ...>     count    <- ask &Map.get(&1, :count)
      ...>     bindings <- ask()
      ...>     return (count == Map.size(bindings))
      ...>   end
      ...>
      ...> sample_bindings = %{count: 3, a: 1, b: 2}
      ...> correct_count   = run(correct, sample_bindings)
      ...> "Correct count for #{inspect sample_bindings}? #{correct_count}"
      "Correct count for %{a: 1, b: 2, count: 3}? true"
      ...>
      ...> bad_bindings = %{count: 100, a: 1, b: 2}
      ...> bad_count    = run(correct, bad_bindings)
      ...> "Correct count for #{inspect bad_bindings}? #{bad_count}"
      "Correct count for %{a: 1, b: 2, count: 100}? false"

  Example adapted from
  [source](https://hackage.haskell.org/package/mtl-2.2.1/docs/Control-Monad-Reader.html)

  """

  alias  __MODULE__
  import Algae
  use    Witchcraft

  defdata fun()

  @doc """
  `Reader` constructor.

  ## Examples

      iex> newbie = new(fn x -> x * 10 end)
      ...> newbie.reader.(10)
      100

  """
  @spec new(fun()) :: t()
  def new(fun), do: %Reader{reader: fun}

  @doc """
  Run the reader function with some argument.

      iex> reader = new(fn x -> x + 5 end)
      ...> run(reader, 42)
      47

  This is the opposite of `new/1`.

      iex> fun = fn x -> x + 5 end
      ...> fun.(42) == fun |> new() |> run(42)
      true

  """
  @spec run(t(), any()) :: any()
  def run(%Reader{reader: fun}, arg), do: fun.(arg)

  @doc """
  Get the wrapped environment. Especially useful in monadic do-notation.

  ## Examples

      iex> run(ask(), 42)
      42

      iex> use Witchcraft
      ...>
      ...> example_fun =
      ...>   fn x ->
      ...>     monad %Algae.Reader{} do
      ...>       e <- ask()
      ...>       return {x, e}
      ...>     end
      ...>   end
      ...>
      ...> 42
      ...> |> example_fun.()
      ...> |> run(7)
      {42, 7}

  """
  @spec ask() :: t()
  def ask, do: Reader.new(fn x -> x end)

  @doc ~S"""
  Similar to `new/1` and `ask/0`. Construct an `Algae.Reader`,
  but apply a function to the constructed envoronment.

  The pun here is that you're "asking" a function for something.

  ## Examples

      iex> fn x -> x * 10 end
      ...> |> ask()
      ...> |> run(5)
      50

      iex> use Witchcraft
      ...>
      ...> foo =
      ...>   fn words ->
      ...>     monad %Algae.Reader{} do
      ...>       loud <- ask &(&1 == String.upcase(&1))
      ...>       return(words <> (if loud, do: "!", else: "."))
      ...>     end
      ...>   end
      ...>
      ...> "Hello" |> foo.() |> run("WORLD") # "WORLD" is the context being asked for
      "Hello!"

  """
  @spec ask((any() -> any())) :: t()
  def ask(fun) do
    monad %Reader{} do
      e <- ask
      return fun.(e)
    end
  end

  @doc """
  Locally composes a function into a `Reader`.

  Often the idea is to temporarily adapt the `Reader` without continuing this
  change in later `run`s.

  ## Examples

      iex> ask()
      ...> |> local(fn word -> word <> "!" end)
      ...> |> local(&String.upcase/1)
      ...> |> run("o hai thar")
      "O HAI THAR!"

  """
  @spec local(t(), (any() -> any())) :: any()
  def local(reader, fun) do
    monad %Reader{} do
      e <- ask
      return run(reader, fun.(e))
    end
  end
end
