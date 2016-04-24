defmodule NBT.Types.Inspect do
  @moduledoc false

  def single do
    quote do
      defimpl Inspect, for: __MODULE__ do
        import Inspect.Algebra

        def inspect(ctx, opts) do
          concat [
            to_doc(ctx.__struct__, opts), "(", to_doc(ctx.name || "None", opts), ") { ",
            to_doc(ctx.data, opts), " }"
          ]
        end
      end
    end
  end

  def collection do
    quote do
      defimpl Inspect, for: __MODULE__ do
        import Inspect.Algebra

        def inspect(ctx, opts) do
          concat [
            to_doc(ctx.__struct__, opts), "(", to_doc(ctx.name || "None", opts),
            ", entries: ", to_doc(length(ctx.data), opts) ,") ",
            to_doc(ctx.data, opts)
          ]
        end
      end
    end
  end

  defmacro __using__(which) when is_atom(which),
    do: apply(__MODULE__, which, [])
end
