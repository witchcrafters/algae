alias  Algae.State
import TypeClass

definst Witchcraft.Chain, for: Algae.State do
  @force_type_instance true

  def chain(state, link) do
    State.state(fn s ->
      {x, z} = State.run(state, s)
      State.run(link.(x), z)
    end)
  end
end
