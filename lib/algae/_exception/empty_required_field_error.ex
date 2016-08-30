defmodule Algae.EmptyRequiredFieldError do
  @moduledoc ~S"""
  """

  alias __MODULE__

  @type t :: %EmptyRequiredFieldError{
    message: String.t,
    field_names: [String.t],
    struct: map,
    plug_status: non_neg_integer
  }

  defexception [
    messgage: "Missing value in required field",
    struct: %{},
    field_names: [],
    plug_status: 500
  ]
end
