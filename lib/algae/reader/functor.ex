alias  Algae.Reader
import TypeClass
use    Witchcraft

definst Witchcraft.Functor, for: Algae.Reader do
  @force_type_instance true
  def map(%Reader{reader: inner}, fun), do: Reader.new(fn e -> e |> inner.() |> fun.() end)
end
