alias  Algae.Reader
import TypeClass

use Quark
use Witchcraft

definst Witchcraft.Apply, for: Algae.Reader do
  @force_type_instance true
  def convey(%Reader{reader: fun_a}, %Reader{reader: fun_b}) do
    Reader.new(fn e -> curry(fun_a).(e).(fun_b.(e)) end)
  end
end
