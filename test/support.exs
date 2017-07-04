## Compiles

import Algae

defdata Complex :: ([{:ok, integer()}] | number()) \\ 22

defdata Any  :: any()
defdata Int  :: integer()
defdata None :: none()

defmodule Embedded.One do
  defdata do: quux :: any() \\ 22
end

defmodule Embedded.Many do
  defdata do
    first  :: any()
    second :: integer() \\ 42
  end
end

defdata Bare do
  first  :: any()
  second :: non_neg_integer() \\ 22
  third  :: any()
end

defmodule Simple do
  defdata any()
end

defmodule Sum.Lights do
  defsum do
    defdata Red    :: any() \\ 22
    defdata Yellow :: any()
    defdata Green  :: none()
  end
end

defmodule Sum.Maybe do
  defsum do
    defdata Just do
      value :: any()
    end

    defdata Nothing :: none()
  end
end
