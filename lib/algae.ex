defmodule Algae do

  @type ast() :: {atom(), any(), any()}

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
      {:::, _, [module_ctx, {:none, _, _} = type]} ->
        caller_module
        |> modules(module_ctx)
        |> data_ast(type)

      {:::, _, [module_ctx, type]} ->
        caller_module
        |> modules(module_ctx)
        |> data_ast(default_value(type), type)

      {:\\, _, [{:::, _, [module_ctx, type]}, default]} ->
        caller_module
        |> modules(module_ctx)
        |> data_ast(default, type)

      {_, _, _} = type ->
        data_ast(caller_module, type)

      [do: {:__block__, _, lines}] ->
        data_ast(lines)

      [do: line] ->
        data_ast([line])
    end
  end

  defmacro defdata(module_ctx, do: body) do
    module_name =
      __CALLER__.module
      |> modules(module_ctx)
      |> Module.concat()

    inner =
      body
      |> case do
           {:__block__, _, lines} -> lines
           line -> List.wrap(line)
      end
      |> data_ast()

    quote do
      defmodule unquote(module_name) do
        unquote(inner)
      end
    end
  end

  @doc """
  Construct a data type AST
  """
  @spec data_ast(module() | [module()], ast()) :: ast()
  def data_ast(lines) when is_list(lines) do
    {field_values, field_types, specs, args, defaults} = module_elements(lines)

    quote do
      @type t :: %__MODULE__{unquote_splicing(field_types)}
      defstruct unquote(field_values)

      @doc "Positional constructor, with args in the same order as they were defined in"
      @spec new(unquote_splicing(specs)) :: t()
      def new(unquote_splicing(args)) do
        struct(__MODULE__, unquote(defaults))
      end
    end
  end

  def data_ast(modules, {:none, _, _}) do
    full_module = Module.concat(modules)

    quote do
      defmodule unquote(full_module) do
        @type t :: %__MODULE__{}

        defstruct []

        @doc "Default #{__MODULE__} struct"
        @spec new() :: t()
        def new, do: struct(__MODULE__)
      end
    end
  end

  def data_ast(caller_module, type) do
    default = default_value(type)

    field =
      caller_module
      |> Module.split()
      |> List.last()
      |> String.downcase()
      |> String.to_atom()

    quote do
      @type t :: %unquote(caller_module){
        unquote(field) => unquote(type)
      }

      defstruct [{unquote(field), unquote(default)}]

      @doc "Default #{__MODULE__} struct"
      @spec new() :: t()
      def new, do: struct(__MODULE__)

      @doc "Constructor helper for piping"
      @spec new(unquote(type)) :: t()
      def new(field), do: struct(__MODULE__, [unquote(field), field])
    end
  end

  @spec data_ast([module()], any(), ast()) :: ast()
  def data_ast(name, default, type_ctx) do
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

  @type field :: {atom(), [any()], [any()]}
  @type type  :: {atom(), [any()], [any()]}

  @spec module_elements([ast()])
     :: {
          [{field(), any()}],
          [{field(), type()}],
          [type],
          [{:\\, [], any()}],
          [{field(), any()}]
        }
  def module_elements(lines) do
    Enum.reduce(lines, {[], [], [], [], []},
      fn(line, {value_acc, type_acc, typespec_acc, acc_arg, acc_mapping}) ->
        {field, type, default_value} = normalize_elements(line)
        arg = {field, [], Elixir}

        {
          [{field, default_value} | value_acc],
          [{field, type} | type_acc],
          [type | typespec_acc],
          [{:\\, [], [arg, default_value]} | acc_arg],
          [{field, arg} | acc_mapping]
        }
      end)
  end

  @spec normalize_elements(ast()) :: {atom(), type(), any()}
  def normalize_elements({:::, _, [{field, _, _}, type]}), do: {field, type, nil}
  def normalize_elements({:\\, _, [{:::, _, [{field, _, _}, type]}, default]}) do
    {field, type, default}
  end

  @doc """
  Generate the AST for a sum type definition
  """
  @spec defsum([do: {:__block__, [any()], ast()}]) :: ast()
  defmacro defsum(do: {:__block__, _, parts} = block) do
    types = or_types(parts, __CALLER__.module)

    quote do
      @type t :: unquote(types)
      unquote(block)
    end
  end

  @spec or_types([ast()], module()) :: [ast()]
  def or_types({:\\, _, [{:::, _, [_, types]}, _]}, module_ctx) do
    or_types(types, module_ctx)
  end

  def or_types([head | tail], module_ctx) do
    Enum.reduce(tail, call_type(head, module_ctx), fn(module, acc) ->
      {:|, [], [call_type(module, module_ctx), acc]}
    end)
  end

  @spec modules(module(), [module()]) :: [module()]
  def modules(top, module_ctx), do: [top | extract_name(module_ctx)]

  @spec call_type(module(), [module()]) :: ast()
  def call_type(new_module, module_ctx) do
    full_module = List.wrap(module_ctx) ++ submodule_name(new_module)
    {{:., [], [{:__aliases__, [alias: false], full_module}, :t]}, [], []}
  end

  @spec submodule_name({:defdata, any(), [{:::, any(), [any()]}]})
     :: [module()]
  def submodule_name({:defdata, _, [{:::, _, [body, _]}]}) do
    body
    |> case do
      {:=, _, [inner_module_ctx, _]} -> inner_module_ctx
      outer_module_ctx -> outer_module_ctx
    end
    |> List.wrap()
  end

  def submodule_name({:defdata, _, [{:\\, _, [{:::, _, [{:__aliases__, _, module}, _]}, _]}]}) do
    List.wrap(module)
  end

  def submodule_name({:defdata, _, [{:__aliases__, _, module}, _]}) do
    List.wrap(module)
  end

  @spec extract_name({any(), any(), atom()} | [module()]) :: [module()]
  def extract_name({_, _, inner_name}), do: List.wrap(inner_name)
  def extract_name(module_chain) when is_list(module_chain), do: module_chain

  # credo:disable-for-lines:21 Credo.Check.Refactor.CyclomaticComplexity
  def default_type({{:., _, [_, :t]}, _, _} = struct_type), do: struct_type

  def default_value({type, _, _}) do
    case type do
      :number  -> 0
      :integer -> 0

      :float -> 0.0

      :pos_integer     -> 1
      :non_neg_integer -> 0

      :bitstring  -> ""
      :list -> []

      :map -> %{}

      :any -> nil
      atom -> atom
    end
  end
end
