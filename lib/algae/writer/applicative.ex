alias  Algae.Writer
import TypeClass
use    Witchcraft

definst Witchcraft.Applicative, for: Algae.Writer do
  @force_type_instance true

  def of(%Writer{writer: {_, log}}, value), do: Writer.new(value, empty(log))
end
