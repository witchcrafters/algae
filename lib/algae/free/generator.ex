# alias Algae.Free.{Deep, Shallow}

# defimpl TypeClass.Property.Generator, for: Shallow do
#   def generate(_) do
#     [1, 1.1, "", []]
#     |> Enum.random()
#     |> TypeClass.Property.Generator.generate()
#     |> Shallow.new()
#   end
# end

# defimpl TypeClass.Property.Generator, for: Deep do
#   def generate(_) do
#     sample = Enum.random([1, 1.1, "", []])

#     a = TypeClass.Property.Generator.generate(sample)
#     b = TypeClass.Property.Generator.generate(sample)
#     c = TypeClass.Property.Generator.generate(sample)

#     a
#     |> Algae.Free.new()
#     |> Algae.Free.layer(Algae.Free.new(b))
#     |> Algae.Free.layer(Algae.Free.new(c))
#   end
# end
