defmodule Algae.RequiredFieldError do
  @moduledoc ~S"""
  Exception for when a required field is missing
  """

  alias __MODULE__

  @type t :: %RequiredFieldError{
    message: String.t,
    field_names: [String.t],
    struct: map,
    plug_status: non_neg_integer
  }

  defexception [
    message: "Missing value in required field",
    struct: %{},
    field_names: [],
    plug_status: 500
  ]
end
