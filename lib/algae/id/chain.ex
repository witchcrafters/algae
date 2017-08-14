import TypeClass

definst Witchcraft.Chain, for: Algae.Id do
  def chain(%{id: data}, link), do: link.(data)
end
