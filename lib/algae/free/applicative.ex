alias  Algae.Free.Pure
import TypeClass

definst Witchcraft.Applicative, for: Algae.Free.Pure do
  def of(_, value), do: %Pure{pure: value}
end

definst Witchcraft.Applicative, for: Algae.Free.Roll do
  def of(_, value), do: %Pure{pure: value}
end
