defmodule NBT do
  @moduledoc """
  NBT - Named Binary Tag

  A library to decode and encode NBT files/data.
  """

  alias NBT.Blob

  @doc "Decode an unnamed NBT data blob"
  def decode(data) do
    data |> Blob.decode
  end

  @doc "Decode an NBT data blob with a given (path) name for reference"
  def decode(data, path_or_name) do
    data |> Blob.decode(path_or_name)
  end

  @doc "Decode an uncompressed NBT file"
  def decode_file(path) do
    path
    |> File.read!
    |> decode(path)
  end

  @doc "Decode a zlib compressed NBT file"
  def decode_gz_file(path) do
    path
    |> File.read!
    |> :zlib.uncompress
    |> decode(path)
  end

  @doc "Decode a gzip compressed NBT file"
  def decode_zlib_file(path) do
    path
    |> File.read!
    |> :zlib.gunzip
    |> decode(path)
  end
end
