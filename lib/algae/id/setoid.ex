import TypeClass
use Witchcraft

definst Witchcraft.Setoid, for: Algae.Id do
  def equivalent?(%{id: a}, %{id: b}), do: a == b
end
