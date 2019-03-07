alias  Algae.Writer
import TypeClass
use    Witchcraft

definst Witchcraft.Applicative, for: Algae.Writer do
  def of(%Writer{writer: {_, log}}, value), do: Writer.new(value, empty(log))
end
