import TypeClass
use Witchcraft

definst Witchcraft.Ord, for: Algae.Id do
  custom_generator(_) do
    1
    |> TypeClass.Property.Generator.generate()
    |> Algae.Id.new()
  end

  def compare(%{id: a}, %{id: b}), do: Witchcraft.Ord.compare(a, b)
end
