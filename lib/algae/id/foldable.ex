import TypeClass

definst Witchcraft.Foldable, for: Algae.Id do
  def right_fold(%{id: data}, seed, fun), do: fun.(data, seed)
end
