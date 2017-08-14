import TypeClass
use Witchcraft

definst Witchcraft.Apply, for: Algae.Id do
  def convey(data, %{id: fun}), do: map(data, fun)
end
