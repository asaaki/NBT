defmodule NBT.Types.IntArray do
  defstruct name: nil,
            data: []

  def new, do: %__MODULE__{}

  defimpl NBT.Decoder, for: __MODULE__ do
    import NBT.Decodable

    def decode(ctx, data, named) do
      ctx
      |> to_state(data, named)
      |> add_name
      |> add_content
    end

    def add_content({ctx, <<len :: big-signed-integer-size(32), value :: binary-size(len)-unit(32), data :: binary>>, _}) do
      {struct(ctx, data: bytes_to_ints(value)), data}
    end

    def bytes_to_ints(bytes), do: bytes_to_ints(bytes, [])

    def bytes_to_ints(<<>>, list),
      do: Enum.reverse(list)
    def bytes_to_ints(<<i :: big-signed-integer-size(32), r :: binary>>, list),
      do: bytes_to_ints(r, [i|list])
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
