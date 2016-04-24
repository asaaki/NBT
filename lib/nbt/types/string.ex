defmodule NBT.Types.String do
  @moduledoc false

  use NBT.Types.Inspect, :single

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
end
