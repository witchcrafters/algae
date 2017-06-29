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
  defmacro defdata({:::, _, [{:=, _, [module_ctx, default_value]}, type_ctx]}) do
    data_ast(module_ctx, default_value, type_ctx)
  end

  defmacro defdata({:::, _, [module_ctx, {type, _, _}]}) do
    data_ast(module_ctx, default_value(type), type)
  end

  def data_ast(name, default, type) when is_list(name) do
    full_module = Module.concat(name)

    field =
      name
      |> List.last()
      |> Atom.to_string()
      |> String.downcase()
      |> String.trim_leading("elixir.")
      |> String.to_atom()

    quote do
      defmodule unquote(full_module) do
        @type t :: %unquote(full_module){
          unquote(field) => unquote(type)
        }

        defstruct [{unquote(field), unquote(default)}]

        @doc "Default #{__MODULE__} struct}"
        @spec new() :: t()
        def new, do: struct(__MODULE__)

        @doc "Helper for initializing struct with a specific value"
        @spec new(unquote(type)()) :: t()
        def new(value), do: struct(__MODULE__, [{unquote(field), value}])
      end
    end
  end

  def data_ast(module_ctx, default_value, ending)do
    name =
      case module_ctx do
        {_, _, inner_name} -> List.wrap(inner_name)
        module_chain when is_list(module_chain) -> module_chain
      end

    type =
      case ending do
        {inner_type, _, _} -> inner_type
        bare_type when is_atom(bare_type) -> bare_type
      end

    data_ast(name, default_value, type)
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
