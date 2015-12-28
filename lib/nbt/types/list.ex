defmodule NBT.Types.List do
  defstruct name: nil,
            data_type: nil,
            data: []

  def new, do: %__MODULE__{}

  defimpl NBT.Decoder, for: __MODULE__ do
    import NBT.Decodable

    def decode(ctx, data, named) do
      ctx
      |> to_state(data, named)
      |> add_name
      |> add_type_and_size
      |> add_content
    end

    def add_type_and_size({
      ctx,
      <<
        data_type :: big-unsigned-integer-size(8),
        list_size :: big-unsigned-integer-size(32),
        data :: binary
      >>,
      _
    }) do
      {struct(ctx, data_type: data_type), data, list_size}
    end

    def add_content({ctx, data, list_size}) do
      {rest, value} = decode_chunks(data, ctx.data_type, list_size)
      {struct(ctx, data: value), rest}
    end

    def decode_chunks(data, data_type, list_size),
      do: decode_chunks(data, data_type, list_size, [])

    def decode_chunks(data, _, 0, list),
      do: {data, Enum.reverse(list)}
    def decode_chunks(data, data_type, list_size, list) do
      {item, rest} = NBT.Decode.decode_typed(data_type, data, false)
      decode_chunks(rest, data_type, list_size - 1, [item|list])
    end
  end

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
