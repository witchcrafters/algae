import Algae

defdata Foo = 42 :: any()
defdata Bar :: integer()
defdata Baz :: none()

defmodule Foo.Quux do
  defdata do: quux :: any()
end

defmodule Id.Foo do
  defdata any()
end

defmodule Lights do
  defsum do
    defdata Red = 22 :: any()
    defdata Yellow :: any()
    defdata Green :: any()
  end
end
