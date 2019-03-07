defmodule AlgaeDslAliasingTest.Base do
  import Algae

  alias __MODULE__

  defmodule A do
    defdata do
      a :: String.t()
    end
  end

  defmodule B do
    defdata do
      b :: Base.A.t() \\ Base.A.new("a for amazing!")
    end
  end

  defmodule C do
    defdata do
      c :: Base.B.t()
    end
  end
end
