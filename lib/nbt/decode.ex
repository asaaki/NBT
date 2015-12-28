defmodule NBT.Decode do
  @moduledoc """
  Decodes raw NBT data into a usable structure
  """

  alias NBT.Decoder
  alias NBT.Types

  @doc false
  def decode(data),
    do: decode(data, true)

  @doc false
  def decode(<<0, data :: binary>>, _),
    do: {:COMPOUND_END, data}

  @doc false
  def decode(data_with_type_id, named)
  for type_id <- (1..11) do
    type_mod = Types.from_id(type_id)
    def decode(<<unquote(type_id), data :: binary>>, named) do
      Decoder.decode(unquote(type_mod).new, data, named)
    end
  end

  @doc false
  def decode_typed(type_id, data_without_type_id, named)
  for type_id <- (1..11) do
    type_mod = Types.from_id(type_id)
    def decode_typed(unquote(type_id), data, named) do
      Decoder.decode(unquote(type_mod).new, data, named)
    end
  end
end
