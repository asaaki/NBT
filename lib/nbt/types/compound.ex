defmodule NBT.Types.Compound do
  @moduledoc false

  use NBT.Types.Inspect, :collection

  defstruct name: nil,
            data: []

  def new, do: %__MODULE__{}

  defimpl NBT.Decoder, for: __MODULE__ do
    import NBT.Decodable
    alias NBT.Decode

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
      case Decode.decode(data) do
        {:COMPOUND_END, rest} ->
          {rest, Enum.reverse(list)}
        {item, rest} ->
          decode_chunks(rest, [item|list])
      end
    end
  end
end
