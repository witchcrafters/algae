alias  Algae.Writer
import TypeClass
use    Witchcraft

definst Witchcraft.Functor, for: Algae.Writer do
  def map(%Writer{writer: {value, log}}, fun), do: Writer.new(fun.(value), log)
end
