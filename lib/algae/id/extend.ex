import TypeClass

definst Witchcraft.Extend, for: Algae.Id do
  def nest(inner), do: Algae.Id.new(inner)
end
