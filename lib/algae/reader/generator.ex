defimpl TypeClass.Property.Generator, for: Algae.Reader do
  def generate(_) do
    fn -> nil end
    |> TypeClass.Property.Generator.generate()
    |> Algae.Reader.new()
  end
end
