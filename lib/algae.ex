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
  defmacro defdata({:::, _, [{:=, _, [module_ctx, default_value]}, {type, _, _}]} = ast) do
    IO.inspect ast
    module = extract_name(module_ctx)
    data_ast(modules(__CALLER__.module, module), default_value, type)
  end

  defmacro defdata({:::, _, [module_ctx, {:none, _, _}]} = ast) do
    data_ast(modules(__CALLER__.module, module_ctx), :none)
  end

  defmacro defdata({:::, _, [module_ctx, {type, _, _}]}) do
    data_ast(modules(__CALLER__.module, module_ctx), default_value(type), type)
  end

  def modules(caller_module, module_ctx) do
    [caller_module | extract_name(module_ctx)]
  end

  defmacro defdata({type, _, _}) when is_atom(type) do
    module =
      __CALLER__.module
      |> Module.split()
      |> Enum.map(&String.to_atom/1)
      |> Module.concat()

    field =
      __CALLER__.module
      |> Module.split()
      |> List.last()
      |> String.downcase()
      |> String.to_atom()

    default = default_value(type)

    quote do
      @type t :: %unquote(module){
        unquote(field) => unquote({type, [], []})
      }

      defstruct [{unquote(field), unquote(default)}]
    end
  end

  defmacro defdata(do: {:::, _, [{field, _, _}, {type, _, _} = full_type]}) do
    module =
      __CALLER__.module
      |> Module.split()
      |> Enum.map(&String.to_atom/1)
      |> Module.concat()

    field =
      __CALLER__.module
      |> Module.split()
      |> List.last()
      |> String.downcase()
      |> String.to_atom()

    default = default_value(type)

    quote do
      @type t :: %unquote(module){
        unquote(field) => unquote(full_type)
      }

      defstruct [{unquote(field), unquote(default)}]
    end
  end

  # defmacro defdata(ast) do
  #   IO.inspect ast
  # end

  def data_ast(name, :none) do
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
          unquote(field) => unquote({type, [], []})
        }

        defstruct [{unquote(field), unquote(default)}]

        @doc "Default #{__MODULE__} struct. Value defaults to #{inspect unquote(default)}."
        @spec new() :: t()
        def new, do: struct(__MODULE__)

        @doc "Helper for initializing struct with a specific value"
        @spec new(unquote(type)()) :: t()
        def new(value), do: struct(__MODULE__, [{unquote(field), value}])
      end
    end
  end

  def data_ast(module_ctx, default_value, ending) do
    type =
      case ending do
        {inner_type, _, _} -> inner_type
        bare_type when is_atom(bare_type) -> bare_type
      end

    data_ast(extract_name(module_ctx), default_value, type)
  end

  def extract_name({_, _, inner_name}), do: List.wrap(inner_name)
  def extract_name(module_chain) when is_list(module_chain), do: module_chain

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

  defmacro defsum(do: {:__block__, _, parts} = ast) do
    quote do
      @type t :: unquote(or_types(parts, __CALLER__.module))
      unquote(ast)
    end
  end

  def or_types([head | tail] = module_list, module_ctx) do
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

  def extract_part_name({:defdata, _, [{:::, _, [{:=, _, [module_ctx, _]}, _]}]}) do
    extract_name(module_ctx)
  end

  def extract_part_name({:defdata, _, [{:::, _, [module_ctx, _]}]}) do
    extract_name(module_ctx)
  end
end
