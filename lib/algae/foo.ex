import Algae

defdata Ex :: ([{:ok, integer()}] | number()) \\ 22

defdata Foo :: any()
defdata Bar :: integer()
defdata Baz :: none()

defmodule Foo.Quux do
  defdata do: quux :: any() \\ 22
end

defmodule Foo.Longer do
  defdata do
    foo :: any()
    bar :: integer() \\ 42
  end
end

defdata Foo.Bare do
  foo :: any()
  bar :: non_neg_integer() \\ 22
  baz :: any()
end

defmodule Id.Foo do
  defdata any()
end

# defmodule Lights do
#   defsum do
#     defdata Red :: any() \\ 22
#     defdata Yellow :: any()
#     defdata Green :: none()
#   end
# end

defmodule Maybe do
  defsum do
    defdata Just do
      value :: any()
    end

    defdata Nothing :: none()
  end
end
