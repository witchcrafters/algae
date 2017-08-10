defmodule Algae.Reader do
  @moduledoc """
  """

  # type Bindings = Map String Int;

  # -- Returns True if the "count" variable contains correct bindings size.
  # isCountCorrect :: Bindings -> Bool
  # isCountCorrect bindings = runReader calc_isCountCorrect bindings

  # -- The Reader monad, which implements this complicated check.
  # calc_isCountCorrect :: Reader Bindings Bool
  # calc_isCountCorrect = do
  #   count <- asks (lookupVar "count")
  #   bindings <- ask
  #   return (count == (Map.size bindings))

  #   -- The selector function to  use with 'asks'.
  #   -- Returns value of the variable with specified name.
  #   lookupVar :: String -> Bindings -> Int
  #   lookupVar name bindings = fromJust (Map.lookup name bindings)

  #   sampleBindings = Map.fromList [("count",3), ("1",1), ("b",2)]

  #   main = do
  #     putStr $ "Count is correct for bindings " ++ (show sampleBindings) ++ ": ";
  #     putStrLn $ show (isCountCorrect sampleBindings);

  alias  __MODULE__
  import Algae
  use    Witchcraft

  defdata fun()

  @doc """
  `Reader` constructor.

  ## Examples

      iex> newbie = new(fn x -> x * 10 end)
      ...> newbie.reader.(10)
      100

  """
  @spec new(fun()) :: t()
  def new(fun), do: %Reader{reader: fun}

  @doc """
  Run the reader function with some argument.

      iex> reader = new(fn x -> x + 5 end)
      ...> run(reader, 42)
      47

  This is the opposite of `new/1`.

      iex> fun = fn x -> x + 5 end
      ...> fun.(42) == fun |> new() |> run(42)
      true

  """
  @spec run(t(), any()) :: any()
  def run(%Reader{reader: fun}, arg), do: fun.(arg)

  # *Main> runR ask 1234
  # 1234

  # runR ask = runR (R $ \e -> e)
  # = runR (R id)
  # = (runR . R) id
  # = id

  @doc """
  Get the wrapped environment. Especially useful in monadic do-notation.

  ## Examples

      iex> run(ask, 42)
      42

      iex> use Witchcraft
      ...>
      ...> example_fun =
      ...>   fn x ->
      ...>     monad %Algae.Reader{} do
      ...>       e <- ask
      ...>       return {x, e}
      ...>     end
      ...>   end
      ...>
      ...> 42
      ...> |> example_fun.()
      ...> |> run(7)
      {42, 7}

  """
  @spec ask() :: t()
  def ask, do: Reader.new(fn x -> x end)

  # ask lets us read the environment and then play with it.
  # asks takes a complementary approach: given a function it returns
  # a Reader which evaluates that function and returns the result.

  # runR (asks length) "Banana"
  # #=> 6
  def asks(fun) do
    monad %Reader{} do
      e <- ask
      return fun.(e)
    end
  end

  # local transforms the environment a Reader sees:
  # *Main> runR ask "Chocolate"
  # "Chocolate"

  # *Main> runR (local (++ " sauce") ask) "Chocolate"
  # "Chocolate sauce"
  def local(reader, fun) do
    monad %Reader{} do
      e <- ask
      return run(reader, fun.(e))
    end
  end
end
