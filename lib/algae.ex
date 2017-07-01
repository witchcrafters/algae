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
  defmacro defdata(ast) do
    caller_module = __CALLER__.module

    case ast do
      {:::, _, [module_ctx, {:none, _, _} = type_ctx]} ->
        caller_module
        |> modules(module_ctx)
        |> data_ast(type_ctx)

      {:::, _, [{:=, _, [module_ctx, default_value]}, type]} ->
        caller_module
        |> modules(module_ctx)
        |> data_ast(default_value, type)

      {:::, _, [module_ctx, type]} ->
        caller_module
        |> modules(module_ctx)
        |> data_ast(default_value(type), type)

      {outer_type, _, _} = type when is_atom(outer_type) ->
        data_ast(caller_module, type)

      [do: {:__block__, _, lines}] ->
        data_ast(lines)

      [do: line] ->
        data_ast([line])
    end
  end

  def modules(top, module_ctx), do: [top | extract_name(module_ctx)]

  def data_ast(lines) when is_list(lines) do
    {field_values, field_types} =
      Enum.reduce(lines, {[], []}, fn
        ({:::, _, [{:=, _, [{field, _, _}, default_value]}, type]}, {value_acc, type_acc}) ->
          {
            [{field, default_value}  | value_acc],
            [{field, type}           | type_acc]
          }

        ({:::, _, [{field, _, _}, type]}, {value_acc, type_acc}) ->
          {
            [{field, nil}  | value_acc],
            [{field, type} | type_acc]
          }
      end)

    quote do
      @type t :: %__MODULE__{
        unquote_splicing(field_types)
      }

      defstruct unquote(field_values)
    end
  end


  defmacro defdata(module_ctx, do: {:__block__, _, body}) do
    module_name =
      __CALLER__.module
      |> modules(module_ctx)
      |> Module.concat()

    inner = data_ast(body)

    quote do
      defmodule unquote(module_name) do
        unquote(inner)
      end
    end
  end

  def data_ast(name, {:none, _, _}) do
    full_module = Module.concat(name)

    quote do
      defmodule unquote(full_module) do
        @type t :: %unquote(full_module){}

        defstruct []

        @doc "Default #{__MODULE__} struct"
        @spec new() :: t()
        def new, do: struct(__MODULE__)
      end
    end
  end

  def data_ast(caller_module, full_type) do
    field =
      caller_module
      |> Module.split()
      |> List.last()
      |> String.downcase()
      |> String.to_atom()

    default = default_value(full_type)

    quote do
      @type t :: %unquote(caller_module){
        unquote(field) => unquote(full_type)
      }

      defstruct [{unquote(field), unquote(default)}]
    end
  end

  def data_ast(name, default, type_ctx) when is_list(name) do
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
          unquote(field) => unquote(type_ctx)
        }

        defstruct [{unquote(field), unquote(default)}]

        @doc "Default #{__MODULE__} struct. Value defaults to #{inspect unquote(default)}."
        @spec new() :: t()
        def new, do: struct(__MODULE__)

        @doc "Helper for initializing struct with a specific value"
        @spec new(unquote(type_ctx)) :: t()
        def new(value), do: struct(__MODULE__, [{unquote(field), value}])
      end
    end
  end

  def extract_name({_, _, inner_name}), do: List.wrap(inner_name)
  def extract_name(module_chain) when is_list(module_chain), do: module_chain

  def default_value({type, _, _}) do
    case type do
      :float -> 0.0

      :number -> 0
      :integer -> 0

      :non_neg_integer -> 0
      :pos_integer -> 1

      :bitstring  -> ""
      :list -> []

      :map -> %{}

      :any -> nil
      atom -> atom
    end
  end

  defmacro defsum(do: {:__block__, _, parts} = block) do
    types = or_types(parts, __CALLER__.module)

    quote do
      @type t :: unquote(types)
      unquote(block)
    end
  end

  def or_types([head | tail], module_ctx) do
    seed =
      head
      |> extract_part_name()
      |> call_type()

    Enum.reduce(tail, seed, fn(module, acc) ->
      normalized_module =
        [module_ctx, extract_part_name(module)]
        |> List.flatten()
        |> Module.concat()
        |> call_type()

      {:|, [], [normalized_module, acc]}
    end)
  end

  def call_type(module) do
    {{:., [], [{:__aliases__, [alias: false], module}, :t]}, [], []}
  end

  def extract_part_name({:defdata, _, [{:::, _, [body, _]}]}) do
    body
    |> case do
      {:=, _, [inner_module_ctx, _]} -> inner_module_ctx
      outer_module_ctx -> outer_module_ctx
    end
    |> extract_name()
  end
end
