import TypeClass
use Witchcraft

definst Witchcraft.Semigroup, for: Algae.Id do
  custom_generator(_) do
    1
    |> TypeClass.Property.Generator.generate()
    |> Algae.Id.new()
  end

  def append(%{id: a}, %{id: b}), do: %Algae.Id{id: a <> b}
end
