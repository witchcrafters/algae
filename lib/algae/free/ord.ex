# alias  Algae.Free.{Deep, Shallow}
# import TypeClass

# definst Witchcraft.Ord, for: Algae.Free.Shallow do
#   custom_generator(_) do
#     1
#     |> TypeClass.Property.Generator.generate()
#     |> Algae.Free.new()
#   end

#   def compare(_, %Deep{}), do: :lesser
#   def compare(%Shallow{shallow: a}, %Shallow{shallow: b}), do: Witchcraft.Ord.compare(a, b)
# end

# definst Witchcraft.Ord, for: Algae.Free.Deep do
#   custom_generator(_) do
#     a = TypeClass.Property.Generator.generate(1)
#     b = TypeClass.Property.Generator.generate(1)
#     c = TypeClass.Property.Generator.generate(1)

#     a
#     |> Algae.Free.new()
#     |> Algae.Free.layer(Algae.Free.new(b))
#     |> Algae.Free.layer(Algae.Free.new(c))
#   end

#   def compare(%Deep{}, %Shallow{}), do: :greater
#   def compare(%Deep{deep: deep_a, deeper: deeper_a}, %Deep{deep: deep_b, deeper: deeper_b}) do
#     case Witchcraft.Ord.compare(deep_a, deep_b) do
#       :equal -> Witchcraft.Ord.compare(deeper_a, deeper_b)
#       result -> result
#     end
#   end
# end
