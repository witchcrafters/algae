import Algae

defdata Foo = 42 :: any()
defdata Bar :: any()

defmodule Lights do
  defsum do
    defdata Red :: any()
    defdata Yellow :: any()
    defdata Green :: any()
  end
end
