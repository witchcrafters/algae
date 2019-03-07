import TypeClass
use Witchcraft

definst Witchcraft.Traversable, for: Algae.Id do
  def traverse(%{id: data}, link) do
    data
    |> link.()
    |> map(&Algae.Id.new/1)
  end
end
