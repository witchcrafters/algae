defimpl TypeClass.Property.Generator, for: Algae.State do
  def generate(_) do
    inner =
      [0, 1.1, "", []]
      |> Enum.random()
      |> TypeClass.Property.Generator.generate()

    Algae.State.new(fn x -> {inner, x} end)
  end
end
