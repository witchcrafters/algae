defmodule Algae.State do
  @moduledoc ~S"""
  `Algae.State` describes a wrapped function that can be used to pass around some
  "hidden" pure state.

  This has numerous applications, but the primary advantage is purity. The state
  gets passed around with the value, and the monadic DSL helps it feel more
  natural than passing everything around by hand.

  In many ways, `Algae.State` is a generalization of `Algae.Reader` and `Algae.Writer`.
  See [Thee Useful Monads](http://adit.io/posts/2013-06-10-three-useful-monads.html#the-state-monad)
  a nice, illustrated guide to how these work and relate.

  ## Anatomy

                # To pass in concrete values
                                ↓
      %Algae.State{runner: fn access -> {value, state} end}
                                           ↑      ↑
                 # "explicit" value position     "hidden" state position

  ## Examples

      iex> use Witchcraft
      ...>
      ...> %Algae.State{}
      ...> |> monad do
      ...>   name <- get()
      ...>   let result = "Hello, #{name}!"
      ...>
      ...>   put result
      ...>   modify &String.upcase/1
      ...>
      ...>   return result
      ...> end
      ...> |> run("world")
      {
        "Hello, world!",
        "HELLO, WORLD!"
      }

      iex> use Witchcraft
      ...>
      ...> pop  = fn -> state(fn([x | xs])       -> {x, xs}   end) end
      ...> pull = fn -> state(fn(list = [x | _]) -> {x, list} end) end
      ...> push = &state(fn(xs) -> {%Witchcraft.Unit{}, [&1 | xs]} end)
      ...>
      ...> %Algae.State{}
      ...> |> monad do
      ...>   push.(["a"])
      ...>   push.(["b"])
      ...>   push.(["c"])
      ...>   push.(["d"])
      ...>   push.(["e"])
      ...>
      ...>   z <- pop.()
      ...>   y <- pop.()
      ...>   x <- pop.()
      ...>
      ...>   push.(x <> y <> z)
      ...>   pull.()
      ...> end
      ...> |> evaluate([])
      ["c", "d", "e"]

  """

  alias __MODULE__
  alias Witchcraft.Unit

  use Witchcraft

  @type runner :: (any() -> {any(), any()})
  @type t :: %State{runner: runner()}

  defstruct [runner: &State.default/1]

  @spec default(any()) :: {integer(), any()}
  def default(s), do: {s, s}

  @doc """
  Construct a new `Algae.State` struct from a state runner in the form
  `fn x -> {y, z} end`

  ## Examples

      iex> new(fn x -> {x + 1, x} end).runner.(42)
      {43, 42}

  """
  @spec new(State.runner()) :: State.t()
  def new(runner), do: %State{runner: runner}

  @doc """
  Alias for `new/1` that reads better when importing the module.

  ## Examples

      iex> state(fn x -> {x + 1, x} end).runner.(42)
      {43, 42}

  """
  @spec state(State.runner()) :: State.t()
  def state(runner), do: new(runner)

  @doc """
  Extract the runner from an `Algae.State`.

  Can be used as a curried version of `run/2`.

  ## Examples

      iex> inner = fn x -> {0, x} end
      ...>
      ...> run(%Algae.State{runner: inner}).(42) == inner.(42)
      true

  """
  @spec run(State.t()) :: State.runner()
  def run(%State{runner: fun}), do: fun

  @doc """
  Run an `Algae.State` by passing in some initial state to actualy run the enclosed
  state runner.

  ## Examples

      iex> use Witchcraft
      ...>
      ...> %Algae.State{}
      ...> |> of(2)
      ...> |> run(0)
      {2, 0}

  """
  @spec run(State.t(), any()) :: any()
  def run(%State{runner: fun}, arg), do: fun.(arg)

  @doc """
  Set the stateful position of an `Algae.Struct`.

  Not unlike `Algae.Writer.tell/1`.

  ## Examples

      iex> 1
      ...> |> put()
      ...> |> run(0)
      {%Witchcraft.Unit{}, 1}

  """
  @spec put(any()) :: State.t()
  def put(s), do: State.new(fn _ -> {%Unit{}, s} end)

  @doc ~S"""
  Run a function over the "state" portion of the runner.

  ## Examples

      iex> fn x -> x + 1 end
      ...> |> modify()
      ...> |> run(42)
      {%Witchcraft.Unit{}, 43}

      iex> use Witchcraft
      ...>
      ...> %Algae.State{}
      ...> |> monad do
      ...>   name <- get()
      ...>
      ...>   put "State"
      ...>   modify &String.upcase/1
      ...>
      ...>   return "Hello, #{name}!"
      ...> end
      ...> |> run("world")
      {"Hello, world!", "STATE"}

  """
  @spec modify((any() -> any())) :: State.t()
  def modify(fun), do: State.new(fn s -> {%Unit{}, fun.(s)} end)

  @doc """
  Set both sides of an `Algae.State` struct.

  ## Examples

      iex> run(get(), 1)
      {1, 1}

  """
  @spec get() :: State.t()
  def get, do: State.new(fn a -> {a, a} end)

  @doc """
  Set both sides of an `Algae.State` struct, plus running a function over the
  value portion of the inner state.

  ## Examples

      iex> fn x -> x * 10 end
      ...> |> get()
      ...> |> run(4)
      {40, 4}

  """
  @spec get((any() -> any())) :: State.t()
  def get(fun) do
    monad %Algae.State{} do
      s <- get()
      return fun.(s)
    end
  end

  @doc ~S"""
  Run the enclosed `Algae.State` runner, and return the value (no state).

  ## Examples

      iex> use Witchcraft
      ...>
      ...> %Algae.State{}
      ...> |> monad do
      ...>   name <- get()
      ...>   put "Ignored"
      ...>   return "Hello, #{name}!"
      ...> end
      ...> |> evaluate("world")
      "Hello, world!"

  """
  @spec evaluate(State.t(), any()) :: any()
  def evaluate(state, value) do
    state
    |> run(value)
    |> elem(0)
  end

  @doc ~S"""
  Run the enclosed `Algae.State` runner, and return the state (no value).

  ## Examples

      iex> fn x -> x + 1 end
      ...> |> get()
      ...> |> execute(1)
      1

      iex> use Witchcraft
      ...>
      ...> %Algae.State{}
      ...> |> monad do
      ...>   whatevs <- get()
      ...>   put "State"
      ...>   return "Hello, #{whatevs}!"
      ...> end
      ...> |> execute("world")
      "State"

  """
  @spec execute(State.t(), any()) :: any()
  def execute(state, value) do
    state
    |> run(value)
    |> elem(1)
  end
end
