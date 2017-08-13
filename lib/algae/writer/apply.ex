alias  Algae.Writer
import TypeClass

use Quark
use Witchcraft

definst Witchcraft.Apply, for: Algae.Writer do
  def convey(%Writer{writer: {value, log_a}}, %Writer{writer: {fun, log_b}}) do
    Writer.new(fun.(value), log_b <> log_a)
  end
end
