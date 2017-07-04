defmodule Algae.Internal do
  @moduledoc false

  @type ast() :: {atom(), any(), any()}

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

      defoverridable [new: unquote(Enum.count(args))]
    end
  end

  def data_ast(modules, {:none, _, _}) do
    full_module = modules |> List.wrap() |> Module.concat()

    quote do
      defmodule unquote(full_module) do
        @type t :: %__MODULE__{}

        defstruct []

        @doc "Default #{__MODULE__} struct"
        @spec new() :: t()
        def new, do: struct(__MODULE__)

        defoverridable [new: 0]
      end
    end
  end

  def data_ast(caller_module, type) do
    default = default_value(type)
    field = module_to_field(caller_module)

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

      defoverridable [new: 0, new: 1]
    end
  end

  @spec data_ast([module()], any(), ast()) :: ast()
  def data_ast(name, default, type_ctx) do
    full_module = Module.concat(name)
    field = module_to_field(name)

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

  @spec embedded_data_ast() :: ast()
  def embedded_data_ast do
    quote do
      @type t :: %__MODULE__{}
      defstruct []

      @doc "Default #{__MODULE__} struct"
      @spec new() :: t()
      def new, do: struct(__MODULE__)
    end
  end

  def embedded_data_ast(module_ctx, default, type_ctx) do
    field = module_to_field(module_ctx)
    quote do
      @type t :: %__MODULE__{
        unquote(field) => unquote(type_ctx)
      }

      defstruct [{unquote(field), unquote(default)}]

      @doc "Default #{__MODULE__} struct"
      @spec new(unquote(type_ctx)) :: t()
      def new(field \\ unquote(default)), do: struct(__MODULE__, [field])

      defoverridable [new: 1]
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
    List.foldr(lines, {[], [], [], [], []},
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
  def normalize_elements({:::, _, [{field, _, _}, type]}) do
    {field, type, default_value(type)}
  end

  def normalize_elements({:\\, _, [{:::, _, [{field, _, _}, type]}, default]}) do
    {field, type, default}
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
      {:\\, _, [inner_module_ctx, _]} -> inner_module_ctx
      {:__aliases__, _, module} -> module
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

  def module_to_field(modules) when is_list(modules) do
    modules
    |> List.last()
    |> module_to_field()
  end

  def module_to_field(module) do
    module
    |> Atom.to_string()
    |> String.split(".")
    |> List.last()
    |> String.downcase()
    |> String.trim_leading("elixir.")
    |> String.to_atom()
  end

  # credo:disable-for-lines:21 Credo.Check.Refactor.CyclomaticComplexity
  def default_value({{:., _, [{_, _, [:String]}, :t]}, _, _}), do: ""

  def default_value({{:., _, [{_, _, adt}, :t]}, _, []}) do
    quote do: unquote(Module.concat(adt)).new()
  end

  def default_value([_]), do: []

  def default_value({type, _, _}) do
    case type do
      :boolean -> false

      :number  -> 0
      :integer -> 0

      :float -> 0.0

      :pos_integer     -> 1
      :non_neg_integer -> 0

      :bitstring  -> ""
      :charlist   -> []

      []    -> []
      :list -> []

      :map  -> %{}

      :fun -> &Quark.id/1
      :->  -> &Quark.id/1

      :any -> nil
      :t   -> raise %Algae.Internal.NeedsExplicitDefaultError{message: "Type is lone `t`"}

      atom -> atom
    end
  end
end
