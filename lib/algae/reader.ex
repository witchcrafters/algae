defmodule Algae.Reader do
  alias Quark, as: Q

  @type t :: %Algae.Reader{reader: (any -> any), env: any}
  defstruct reader: &Q.id/1, env: {}

  @doc ~S"""
  Simply invoke the `reader` function on the contained `env`ironment
  """
  @spec read(Algae.Reader.t) :: any
  def read(%Algae.Reader{env: env, reader: reader}), do: Q.Curry.curry(reader).(env)
end
