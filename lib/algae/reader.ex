defmodule Algae.Reader do
  alias __MODULE__

  @type t :: %Algae.Reader{reader: fun, env: any}
  defstruct reader: &Quark.id/1, env: {}

  @doc ~S"""
  Simply invoke the `reader` function on the contained `env`ironment
  """
  @spec read(t) :: any
  def read(%Reader{env: env, reader: reader}) do
    Quark.Curry.curry(reader).(env)
  end
end
