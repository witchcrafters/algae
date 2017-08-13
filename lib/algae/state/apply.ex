alias  Algae.State
import TypeClass

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
