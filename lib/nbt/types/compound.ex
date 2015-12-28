defmodule NBT.Types.Compound do
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

    def add_content({ctx, data, _}) do
      {rest, value} = decode_chunks(data)
      {struct(ctx, data: value), rest}
    end

    def decode_chunks(data),
      do: decode_chunks(data, [])

    def decode_chunks(data, list) do
      case NBT.Decode.decode(data) do
        {:COMPOUND_END, rest} ->
          {rest, Enum.reverse(list)}
        {item, rest} ->
          decode_chunks(rest, [item|list])
      end
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
