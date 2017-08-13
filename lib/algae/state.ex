defmodule Algae.State do

  alias __MODULE__

  defstruct [state: &Algae.State.default/1]

  defp default(s), do: {0, s}

  def new(stepper), do: %State{state: stepper}

  def run(%State{state: fun}), do: fun

  def run(%State{state: fun}, arg), do: fun.(arg)

  def put(s), do: State.new(fn _ -> {%Witchcraft.Unit{}, s} end)

  def get, do: State.new(fn a -> {a, a} end)

  def eval(state, a) do
    state
    |> run(a)
    |> elem(0)
  end
end

alias Algae.State
import TypeClass
use Witchcraft

defimpl TypeClass.Property.Generator, for: Algae.State do
  def generate(_) do
    inner =
      [0, 1.1, "", []]
      |> Enum.random()
      |> TypeClass.Property.Generator.generate()

    State.new(fn x -> {inner, x} end)
  end
end

definst Witchcraft.Functor, for: Algae.State do
  @force_type_instance true

  def map(%State{state: inner}, fun) do
    run_map  = fn({a, b}, f) -> {f.(a), b} end

    st_tuple =
      fn(g, s) ->
        g
        |> State.new()
        |> State.run(s)
      end

    State.new(fn x ->
      inner
      |> st_tuple.(x)
      |> run_map.(fun)
    end)
  end
end

definst Witchcraft.Apply, for: Algae.State do
  @force_type_instance true
  def convey(%State{state: state_g}, %State{state: state_f}) do
    fg =
      fn(s) ->
        {x, t} = state_f.(s)
        {y, u} = state_g.(t)
        {x.(y), u}
      end

    State.new(fn x -> fg.(x) end)
  end
end

definst Witchcraft.Applicative, for: Algae.State do
  @force_type_instance true
  def of(_, value), do: State.new(fn x -> {value, x} end)
end

definst Witchcraft.Chain, for: Algae.State do
  @force_type_instance true
  def chain(%State{state: inner}, link) do
    fn s ->
      {x, s} = inner.(s)
      link.(x)
    end
  end
end
