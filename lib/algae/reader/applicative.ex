alias  Algae.Reader
import TypeClass
use    Witchcraft

definst Witchcraft.Applicative, for: Algae.Reader do
  @force_type_instance true
  def of(_, value), do: Reader.new(fn _ -> value end)
end
