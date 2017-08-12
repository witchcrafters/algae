defmodule Algae.Reader do
  @moduledoc ~S"""
  `Reader` allow you to pass some readable context around through actions.

  This is useful in a number of situations, but the most common case is to weave
  access to environment variables monadically.

  ## Examples

      iex> defmodule Count do
      ...>   import Algae.Reader
      ...>   use Witchcraft
      ...>
      ...>   def correct?(bindings), do: run(calc_correct(), bindings)
      ...>
      ...>   def calc_correct do
      ...>     monad %Algae.Reader{} do
      ...>       count    <- asks &Map.get(&1, :count)
      ...>       bindings <- ask()
      ...>       return (count == Map.size(bindings))
      ...>     end
      ...>   end
      ...> end
      ...>
      ...> sample_bindings = %{count: 3, a: 1, b: 2}
      ...> correct_count   = Count.correct?(sample_bindings)
      ...> "Count is correct for bindings #{inspect sample_bindings}: #{correct_count}"
      "Count is correct for bindings %{a: 1, b: 2, count: 3}: true"

  [Example source](https://hackage.haskell.org/package/mtl-2.2.1/docs/Control-Monad-Reader.html)

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

  # *Main> runR ask 1234
  # 1234

  # runR ask = runR (R $ \e -> e)
  # = runR (R id)
  # = (runR . R) id
  # = id

  @doc """
  Get the wrapped environment. Especially useful in monadic do-notation.

  ## Examples

      iex> run(ask, 42)
      42

      iex> use Witchcraft
      ...>
      ...> example_fun =
      ...>   fn x ->
      ...>     monad %Algae.Reader{} do
      ...>       e <- ask
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
  Similar to `new`, construct a `Reader` from a function, reading from the passed context.

  ## Examples

      iex> fn x -> x * 10 end
      ...> |> asks()
      ...> |> run(5)
      50

      iex> use Witchcraft
      ...>
      ...> foo =
      ...>   fn words ->
      ...>     monad %Algae.Reader{} do
      ...>       loud <- asks &(&1 == String.upcase(&1))
      ...>       return(words <> (if loud, do: "!", else: "."))
      ...>     end
      ...>   end
      ...>
      ...> "Hello" |> foo.() |> run("WORLD") # "WORLD" is the context being asked for
      "Hello!"

  """
  @spec asks((any() -> any())) :: t()
  def asks(fun) do
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
