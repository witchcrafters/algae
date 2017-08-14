import TypeClass

definst Witchcraft.Functor, for: Algae.Id do
  def map(%{id: data}, fun), do: data |> fun.() |> Algae.Id.new()
end
