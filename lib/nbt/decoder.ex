defprotocol NBT.Decoder do
  @fallback_to_any true

  def decode(type, data, named)
end

defimpl NBT.Decoder, for: Any do
  def decode(_type, data, _named) do
    data
  end
end
