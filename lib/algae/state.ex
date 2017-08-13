defmodule Algae.State do

  alias __MODULE__
  alias Witchcraft.Unit

  use Witchcraft

  @type stepper :: (any() -> {any(), any()})
  @type t :: %State{state: stepper()}

  defstruct [state: &State.default/1]

  @spec default(any()) :: {integer(), any()}
  defp default(s), do: {0, s}

  @spec new(State.stepper()) :: State.t()
  def new(stepper), do: %State{state: stepper}

  @spec state(State.stepper()) :: State.t()
  def state(stepper), do: new(stepper)

  @spec run(State.t()) :: State.stepper()
  def run(%State{state: fun}), do: fun

  @spec run(State.t(), any()) :: any()
  def run(%State{state: fun}, arg), do: fun.(arg)

  @spec put(any()) :: State.t()
  def put(s), do: State.new(fn _ -> {%Unit{}, s} end)

  @spec get() :: State.t()
  def get, do: State.new(fn a -> {a, a} end)

  @spec get((any() -> any())) :: State.t()
  def get(fun) do
    monad %State{} do
      s <- get()
      return fun.(s)
    end
  end

  @spec eval(State.t(), any()) :: any()
  def eval(state, a) do
    state
    |> run(a)
    |> elem(0)
  end

  @spec modify((any() -> any())) :: State.t()
  def modify(fun), do: State.new(fn s -> {%Unit{}, fun.(s)} end)
end
