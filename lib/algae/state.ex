defmodule Algae.State do
  @moduledoc ~S"""












  ## Examples

      iex> use Witchcraft
      ...>
      ...> greeter =
      ...>   monad %Algae.State{} do
      ...>     name <- get()
      ...>     put "tintin"
      ...>     return "hello, #{name}!"
      ...>   end
      ...>
      ...> run(greeter, "adit")
      {"hello, adit!", "tintin"}

      iex> use Witchcraft
      ...>
      ...> push = fn x -> state(fn(xs) -> {%Witchcraft.Unit{}, [x | xs]} end) end
      ...> pop  = fn -> state(fn([x | xs]) -> {x, xs} end) end
      ...> tos  = fn -> state(fn(list) = [x | _] -> {x, list} end) end
      ...>
      ...> %Algae.State{}
      ...> |> monad do
      ...>   push.(10)
      ...>   push.(20)
      ...>
      ...>   a <- pop.()
      ...>   b <- pop.()
      ...>
      ...>   push.(a + b)
      ...>
      ...>   tos.()
      ...> end
      ...> |> evaluate([])
      30

  """

  alias __MODULE__
  alias Witchcraft.Unit

  use Witchcraft

  @type runner :: (any() -> {any(), any()})
  @type t :: %State{state: runner()}

  defstruct [state: &State.default/1]

  @spec default(any()) :: {integer(), any()}
  defp default(s), do: {0, s}

  @spec new(State.runner()) :: State.t()
  def new(runner), do: %State{state: runner}

  @spec state(State.runner()) :: State.t()
  def state(runner), do: new(runner)

  @doc """






  ## Examples

      iex> inner = fn x -> {0, x} end
      ...>
      ...> run(%Algae.State{state: inner}).(42) == inner.(42)
      true

  """
  @spec run(State.t()) :: State.runner()
  def run(%State{state: fun}), do: fun

  @doc """




  ## Examples

      iex> use Witchcraft
      ...>
      ...> %Algae.State{}
      ...> |> of(2)
      ...> |> run(0)
      {2, 0}

  """
  @spec run(State.t(), any()) :: any()
  def run(%State{state: fun}, arg), do: fun.(arg)

  @doc """





  ## Examples

      iex> 1
      ...> |> put()
      ...> |> run(0)
      {%Witchcraft.Unit{}, 1}

  """
  @spec put(any()) :: State.t()
  def put(s), do: State.new(fn _ -> {%Unit{}, s} end)

  # -- >>> runState get 0
  # -- (0,0)

  @doc """




  ## Examples

      iex> run(get(), 1)
      {1, 1}

  """
  @spec get() :: State.t()
  def get, do: State.new(fn a -> {a, a} end)

  @doc """






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

  @doc """





  ## Examples

      # iex>

  """
  @spec evaluate(State.t(), any()) :: any()
  def evaluate(state, value) do
    state
    |> run(value)
    |> elem(0)
  end

  @doc """






  ## Examples

      iex> fn x -> x + 1 end
      ...> |> get()
      ...> |> execute(1)
      1

  """
  @spec execute(State.t(), any()) :: any()
  def execute(state, value) do
    state
    |> run(value)
    |> elem(1)
  end

  @spec modify((any() -> any())) :: State.t()
  def modify(fun), do: State.new(fn s -> {%Unit{}, fun.(s)} end)
end
