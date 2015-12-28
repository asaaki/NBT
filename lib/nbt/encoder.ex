defmodule NBT.Encode do
  @moduledoc false

  def encode(data, tree) do
    {data, tree}
  end
end

defprotocol NBT.Encoder do
  @fallback_to_any true

  def encode(data, tree)
end

defimpl NBT.Encoder, for: Any do
  def encode(data, _tree) do
    data
  end
end
