# alias  Algae.Free.{Deep, Shallow}
# import TypeClass

# definst Witchcraft.Functor, for: Algae.Free.Shallow do
#   def map(%Shallow{shallow: data}, fun) do
#     %Shallow{shallow: Witchcraft.Functor.map(data, fun)}
#   end
# end

# definst Witchcraft.Functor, for: Algae.Free.Deep do
#   # fmap f (Roll x) = Roll (fmap (fmap f) x)
#   def map(deep = %Deep{deep: data}, fun) do
#     new_deep =
#       Witchcraft.Functor.map(data, fn x ->
#         Witchcraft.Functor.map(fun, x)
#       end)

#     %{deep | deep: new_deep}
#   end
# end
