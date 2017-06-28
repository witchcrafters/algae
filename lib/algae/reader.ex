defmodule Algae.Reader do
  @moduledoc ~S"""
  A helpful way to store some data, and access it with a set function

  `reader` defaults to returning all of `env`

  ## Examples

      iex> %Algae.Reader{env: "stuff to check"}
      %Algae.Reader{env: "stuff to check", reader: &Quark.id/1}

  """

  alias __MODULE__

  @type t :: %Reader{reader: fun(), env: any()}
  defstruct reader: &Quark.id/1, env: {}

  @doc ~S"""
  Simply invoke the `reader` function on the contained `env`ironment

  Note that this auto-curries the `reader` for convenience (and to make several
  cases even possible).

  ## Examples

      iex> %Algae.Reader{env: 42} |> Algae.Reader.run
      42

      iex> config =
      ...>   %Algae.Reader{
      ...>     reader: &Map.get/2,
      ...>     env: %{
      ...>       uri:   "https://api.awesomeservice.com",
      ...>       token: "12345"
      ...>     }
      ...>   }
      ...> :uri |> Algae.Reader.run(config).()
      "https://api.awesomeservice.com"

      > elapsed_time =
      >  %Algae.Reader.new{
      >    env: %{start_time: 1472717375},
      >    reader:
      >      fn %{start_time: start_time} ->
      >        now = DateTime.now |> DateTime.to_unix
      >        "#{now - start_time}ms"
      >      end
      >    }
      >  run(elapsed_time)
      "42ms"

  """
  @spec run(t()) :: any()
  def run(%{env: env, reader: reader}), do: Quark.Curry.curry(reader).(env)

  @doc ~S"""
  Alias for `run`

  ## Examples

        iex> forty_two = %Algae.Reader{env: 42}
        ...> forty_two |> read
        42

        iex> config =
        ...>   %Algae.Reader{
        ...>     reader: &Map.get/2,
        ...>     env: %{
        ...>       uri:   "https://api.awesomeservice.com",
        ...>       token: "12345"
        ...>     }
        ...>   }
        ...> read(config).(:uri)
        "https://api.awesomeservice.com"

        > elapsed_time =
        >  %Algae.Reader.new{
        >    env: %{start_time: 1472717375},
        >    reader:
        >      fn %{start_time: start_time} ->
        >        now = DateTime.now |> DateTime.to_unix
        >        "#{now - start_time}ms"
        >      end
        >    }
        >  read elapsed_time
        "42ms"

  """
  @spec read(t()) :: any()
  def read(reader), do: run(reader)
end
