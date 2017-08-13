alias  Algae.Writer
import TypeClass

use Quark
use Witchcraft

definst Witchcraft.Apply, for: Algae.Writer do
  @force_type_instance true

  def convey(%Writer{writer: {fun, log_a}}, %Writer{writer: {value, log_b}}) do
    Writer.new({fun.(value), log_b <> log_a})
  end
end
