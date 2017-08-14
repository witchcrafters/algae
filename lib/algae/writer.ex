defmodule Algae.Writer do
  @moduledoc ~S"""
  `Algae.Writer` helps capture the pattern of writing to a pure log or accumulated
  value, handling the bookkeeping for you.

  If `Algae.Reader` is quasi-read-only, `Algae.Writer` is quasi-write-only.
  This is often used for loggers, but could be anything as long as the hidden value
  is a `Witchcraft.Monoid`.

  There are many applications of `Writer`s, but as an illustrative point,
  one could use it for logging across processes and time, since the log
  is carried around with the result in a pure fashion. The monadic DSL
  helps make using these feel more natural.

  For an illustrated guide to `Writer`s,
  see [Thee Useful Monads](http://adit.io/posts/2013-06-10-three-useful-monads.html#the-state-monad).

  ## Anatomy

        %Algae.Writer{writer: {value, log}}
                                 ↑     ↑
       # "explicit" value position    "hidden" position,
       #                               commonly used as a log

  ## Examples

      iex> use Witchcraft
      ...>
      ...> excite =
      ...>   fn string ->
      ...>     monad writer({0.0, "log"}) do
      ...>       tell string
      ...>
      ...>       excited <- return "#{string}!"
      ...>       tell " => #{excited} ... "
      ...>
      ...>       return excited
      ...>     end
      ...>   end
      ...>
      ...> {_, logs} =
      ...>   "Hi"
      ...>   |> excite.()
      ...>   >>> excite
      ...>   >>> excite
      ...>   |> censor(&String.trim_trailing(&1, " ... "))
      ...>   |> run()
      ...>
      ...> logs
      "Hi => Hi! ... Hi! => Hi!! ... Hi!! => Hi!!!"

      iex> use Witchcraft
      ...>
      ...> exponent =
      ...>   fn num ->
      ...>     monad writer({0, 0}) do
      ...>       tell 1
      ...>       return num * num
      ...>     end
      ...>   end
      ...>
      ...> initial = 42
      ...> {result, times} = run(exponent.(initial) >>> exponent >>> exponent)
      ...>
      ...> "#{initial}^#{round(:math.pow(2, times))} = #{result}"
      "42^8 = 9682651996416"

  """

  alias __MODULE__
  alias Witchcraft.{Monoid, Unit}
  use   Witchcraft

  @type log    :: Monoid.t()
  @type value  :: any()
  @type writer :: {Writer.value(), Writer.log()}

  @type t :: %Writer{writer: writer()}

  defstruct writer: {0, []}

  @doc """
  Construct a `Algae.Writer` struct from a starting value and log.

  ## Examples

      iex> new()
      %Algae.Writer{writer: {0, []}}

      iex> new("hi")
      %Algae.Writer{writer: {"hi", []}}

      iex> new("ohai", 42)
      %Algae.Writer{writer: {"ohai", 42}}

  """
  @spec new(any(), Monoid.t()) :: Writer.t()
  def new(value \\ 0, log \\ []), do: %Writer{writer: {value, log}}

  @doc """
  Similar to `new/2`, but taking a tuple rather than separate fields.

  ## Examples

      iex> writer({"ohai", 42})
      %Algae.Writer{writer: {"ohai", 42}}

  """
  @spec writer(Writer.writer()) :: Writer.t()
  def writer({value, log}), do: new(value, log)

  @doc ~S"""
  Extract the enclosed value and log from an `Algae.Writer`.

  ## Examples

      iex> run(%Algae.Writer{writer: {"hi", "there"}})
      {"hi", "there"}

      iex> use Witchcraft
      ...>
      ...> half =
      ...>   fn num ->
      ...>     monad writer({0.0, ["log"]}) do
      ...>       let half = num / 2
      ...>       tell ["#{num} / 2 = #{half}"]
      ...>       return half
      ...>     end
      ...>   end
      ...>
      ...> run(half.(42) >>> half >>> half)
      {
        5.25,
        [
          "42 / 2 = 21.0",
          "21.0 / 2 = 10.5",
          "10.5 / 2 = 5.25"
        ]
      }

  """
  @spec run(Writer.t()) :: Writer.value()
  def run(%Writer{writer: writer}), do: writer

  @doc ~S"""
  Set the "log" portion of an `Algae.Writer` step

  ## Examples

      iex> tell("secrets")
      %Algae.Writer{writer: {%Witchcraft.Unit{}, "secrets"}}

      iex> use Witchcraft
      ...>
      ...> monad %Algae.Writer{writer: {"string", 1}} do
      ...>   tell 42
      ...>   tell 43
      ...>   return "hey"
      ...> end
      %Algae.Writer{writer: {"hey", 85}}

      iex> use Witchcraft
      ...>
      ...> half =
      ...>   fn num ->
      ...>     monad writer({0.0, ["log"]}) do
      ...>       let half = num / 2
      ...>       tell ["#{num} / 2 = #{half}"]
      ...>       return half
      ...>     end
      ...>   end
      ...>
      ...> run(half.(42.0) >>> half >>> half)
      {
        5.25,
        [
          "42.0 / 2 = 21.0",
          "21.0 / 2 = 10.5",
          "10.5 / 2 = 5.25"
        ]
      }

  """
  @spec tell(Writer.log()) :: Writer.t()
  def tell(log), do: new(%Unit{}, log)

  @doc """
  Copy the log into the value position. This makes it accessible in do-notation.

  ## Examples

      iex> listen(%Algae.Writer{writer: {42, "hi"}})
      %Algae.Writer{writer: {{42, "hi"}, "hi"}}

      iex> use Witchcraft
      ...>
      ...> monad new(1, 1) do
      ...>   wr <- listen tell(42)
      ...>   tell 43
      ...>   return wr
      ...> end
      %Algae.Writer{
        writer: {{%Witchcraft.Unit{}, 42}, 85}
      }

  """
  @spec listen(Writer.t()) :: Writer.t()
  def listen(%Writer{writer: {value, log}}), do: %Writer{writer: {{value, log}, log}}

  @doc """
  Similar to `listen/1`, but with the ability to adjust the copied log.

  ## Examples

      iex> listen(%Algae.Writer{writer: {1, "hi"}}, &String.upcase/1)
      %Algae.Writer{
        writer: {{1, "HI"}, "hi"}
      }

  """
  @spec listen(Writer.t(), (log() -> log())) :: Writer.t()
  def listen(writer, fun) do
    monad writer do
      {value, log} <- listen writer
      return {value, fun.(log)}
    end
  end

  @doc ~S"""
  Run a function in the value portion of an `Algae.Writer` on the log.

  Notice that the structure is similar to what somes out of `listen/{1,2}`

      Algae.Writer{writer: {{_, function}, log}}

  ## Examples

      iex> pass(%Algae.Writer{writer: {{1, fn x -> x * 10 end}, 42}})
      %Algae.Writer{writer: {1, 420}}

      iex> use Witchcraft
      ...>
      ...> monad new("string", ["logs"]) do
      ...>   a <-  ["start"] |> tell() |> listen()
      ...>   tell ["middle"]
      ...>
      ...>   {value, logs} <- return a
      ...>   pass writer({{value, fn [log | _] -> [log | [log | logs]] end}, logs})
      ...>
      ...>   tell ["next is 42"]
      ...>   return 42
      ...> end
      %Algae.Writer{
        writer: {42, ["start", "middle", "start", "start", "start", "next is 42"]}
      }

  """
  @spec pass(Writer.t()) :: Writer.t()
  def pass(%Writer{writer: {{value, fun}, log}}), do: %Writer{writer: {value, fun.(log)}}

  @doc ~S"""
  Run a writer, and run a function over the resulting log.

  ## Examples

      iex> 42
      ...> |> new(["hi", "THERE", "friend"])
      ...> |> censor(&Enum.reject(&1, fn log -> String.upcase(log) == log end))
      ...> |> run()
      {42, ["hi", "friend"]}

      iex> use Witchcraft
      ...>
      ...> 0
      ...> |> new(["logs"])
      ...> |> monad do
      ...>   tell ["Start"]
      ...>   tell ["BANG!"]
      ...>   tell ["shhhhhhh..."]
      ...>   tell ["LOUD NOISES!!!"]
      ...>   tell ["End"]
      ...>
      ...>   return 42
      ...> end
      ...> |> censor(&Enum.reject(&1, fn log -> String.upcase(log) == log end))
      ...> |> run()
      {42, ["Start", "shhhhhhh...", "End"]}

  """
  @spec censor(Writer.t(), (any() -> any())) :: Writer.t()
  def censor(writer, fun) do
    pass(monad writer do
      value <- writer
      return {value, fun}
    end)
  end
end
