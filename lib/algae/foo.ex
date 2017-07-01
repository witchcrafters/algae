import Algae

# defdata Ex = 42 :: [{:ok, integer()}] | number()

defdata Foo = 42 :: any()
defdata Bar :: integer()
defdata Baz :: none()

defmodule Foo.Quux do
  defdata do: quux :: any()
end

defmodule Foo.Longer do
  defdata do
    foo :: any()
    bar = 42 :: integer()
  end
end

# defdata Foo.Bare do
#   foo :: any()
#   bar = 22 :: non_neg_integer()
# end

defmodule Id.Foo do
  defdata any()
end

defmodule Lights do
  defsum do
    defdata Red = 22 :: any()
    defdata Yellow :: any()
    defdata Green :: none()
  end
end
