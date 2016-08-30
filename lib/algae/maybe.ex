defmodule Algae.Maybe do
  @moduledoc ~S"""
  """

  alias __MODULE__.Just
  alias __MODULE__.Nothing

  use Quark.Partial

  @type t :: Just.t | Nothing.t

  def nothing(), do: %Algae.Maybe.Nothing{}
  defpartial just(value), do: %Algae.Maybe.Just{just: value}

  defdelegate nothing(),   to: Nothing, as: :new

  defdelegate just(), to: Just, as: new
  defdelegate just(value), to: Just, as: new

  defdelegate maybe(), to: __MODULE__, as: :nothing
  defdelegate maybe(value), to: __MODULE__, as: :just
end
