defimpl TypeClass.Property.Generator, for: Algae.Id do
  def generate(_) do
    [1, 1.1, "", []]
    |> Enum.random()
    |> TypeClass.Property.Generator.generate()
    |> Algae.Id.new()
  end
end
