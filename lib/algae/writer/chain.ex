alias  Algae.Writer
import TypeClass
use    Witchcraft

definst Witchcraft.Chain, for: Algae.Writer do
  def chain(%Writer{writer: {old_value, old_log}}, link) do
    %Writer{writer: {new_value, new_log}} = link.(old_value)
    Writer.new(new_value, old_log <> new_log)
  end
end
