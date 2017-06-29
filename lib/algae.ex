defmodule Algae do

  @doc """
  --- Id --

  defmodule Id do
    defdata do: id :: any()
  end

  --- Sum ---

  defmodule Either do
    defsum do
      defdata Left  :: any()
      defdata Right :: any()
    end
  end

  defmodule Either do
    defdata do: Left :: any() | Right :: any()
  end

  --- Product --

  defmodule Rectangle do
    data do: width :: number(), height :: number()
  end

  -- Both --

  data Stree a = Tip | Node (Stree a) a (Stree a)
  defmodule Stree do
    defdata do
        Tip :: any() | Node :: (left :: t()), (middle = 42 :: any()), (right :: t())
    end
  end

  defmodule Stree do
    defsum do
      defdata Tip :: any()

      defproduct Node do
        left :: Stree.t()
        middle = 42 :: any()
        right :: Stree.t()
      end
    end
  end
  """

  defmacro defdata(do: body) do
    quote do
      defdata(__MODULE__, do: unquote(body))
    end
  end

  defmacro defdata(adt_name, do: body) do
    quote do
      defmodule unqoute(adt_name) do

        # def new do
        # end
      end
    end
  end

  # defdata Left  :: any()
  defmacro defdata({:::, _, [{:=, _, [{_, _, [name]}, default]}, {type, _, _}]}) do
    field =
      name
      |> Atom.to_string()
      |> String.downcase()
      |> String.trim_leading("elixir.")
      |> String.to_atom()

    full_module = Module.concat([name])

    quote do
      defmodule unquote(full_module) do
        @type t :: unquote(type)()
        defstruct [{unquote(field), unquote(default)}]

        def new(value), do: struct(__MODULE__, [{unquote(field), value}])
      end
    end
  end

  def default_value(type) do
    case type do
      :float -> 0.0

      :number -> 0
      :integer -> 0

      :non_neg_integer -> 0
      :pos_integer -> 1

      :bitstring  -> ""
      :list -> []

      :map -> %{}

      :nil -> nil
      :any -> nil
    end
  end
end
