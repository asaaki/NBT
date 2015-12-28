defmodule NBT.Types.String do
  defstruct name: nil,
            data: <<>>

  def new, do: %__MODULE__{}

  defimpl NBT.Decoder, for: __MODULE__ do
    import NBT.Decodable

    def decode(ctx, data, named) do
      ctx
      |> to_state(data, named)
      |> add_name
      |> add_content
    end

    def add_content({ctx, <<len :: big-unsigned-integer-size(16), value :: binary-size(len), data :: binary>>, _}) do
      {struct(ctx, data: value), data}
    end
  end

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