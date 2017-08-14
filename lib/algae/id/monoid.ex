import TypeClass

definst Witchcraft.Monoid, for: Algae.Id do
  def empty(%{id: sample}), do: sample |> Witchcraft.Monoid.empty() |> Algae.Id.new()
end
