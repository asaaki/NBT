defmodule NBT.Blob do
  @moduledoc false

  alias NBT.RawBlob

  defstruct name: nil,
            data: nil

  def new(data),
    do: new(data, nil)

  def new(data, name),
    do: RawBlob.new(data, name)

  def decode(data),
    do: decode(data, nil)

  def decode(data, name),
    do: RawBlob.decode(data, name)

  ### Protocol implementations ###

  defimpl Inspect, for: __MODULE__ do
    import Inspect.Algebra

    def inspect(ctx, opts) do
      concat [
        to_doc(ctx.__struct__, opts), "(", to_doc(ctx.name || "None", opts), ") {{ ",
        to_doc(ctx.data, opts), " }}"
      ]
    end
  end
end
