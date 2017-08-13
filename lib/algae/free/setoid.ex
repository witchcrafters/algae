# alias  Algae.Free.{Deep, Shallow}
# import TypeClass

# definst Witchcraft.Setoid, for: Algae.Free.Shallow do
#   custom_generator(_) do
#     1
#     |> TypeClass.Property.Generator.generate()
#     |> Algae.Free.new()
#   end

#   def equivalent?(_, %Deep{}), do: false

#   def equivalent?(%Shallow{shallow: a}, %Shallow{shallow: b}) do
#     Witchcraft.Setoid.equivalent?(a, b)
#   end
# end

# definst Witchcraft.Setoid, for: Algae.Free.Deep do
#   custom_generator(_) do
#     a = TypeClass.Property.Generator.generate(1)
#     b = TypeClass.Property.Generator.generate(1)
#     c = TypeClass.Property.Generator.generate(1)

#     a
#     |> Algae.Free.new()
#     |> Algae.Free.layer(Algae.Free.new(b))
#     |> Algae.Free.layer(Algae.Free.new(c))
#   end

#   def equivalent?(_, %Shallow{}), do: false

#   def equivalent?(%Deep{deep: deep_a, deeper: deeper_a}, %Deep{deep: deep_b, deeper: deeper_b}) do
#     Witchcraft.Setoid.equivalent?(deep_a, deep_b)
#     and Witchcraft.Setoid.equivalent?(deeper_a, deeper_b)
#   end
# end
