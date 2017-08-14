import TypeClass

definst Witchcraft.Applicative, for: Algae.Id do
  def of(_, data), do: Algae.Id.new(data)
end
