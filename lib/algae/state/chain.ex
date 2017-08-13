alias  Algae.State
import TypeClass

definst Witchcraft.Chain, for: Algae.State do
  @force_type_instance true
  def chain(%State{state: inner}, link) do
    fn s ->
      {x, s} = inner.(s)
      link.(x)
    end
  end
end
