alias  Algae.State
import TypeClass

definst Witchcraft.Functor, for: Algae.State do
  @force_type_instance true

  def map(%State{runner: inner}, fun) do
    run_map = fn({a, b}, f) -> {f.(a), b} end

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
