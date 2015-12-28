defmodule NBT.Playground do
  def type_tests do
    # type, name, data, remainder (always 'REST')
    # type 0 (compound end) has no name or data (it's just a marker for compound)
    [
      NBT.Decode.decode(<<0,                                       82,69,83,84>>),
      NBT.Decode.decode(<<1,  0,2,64,65, 82,                       82,69,83,84>>),
      NBT.Decode.decode(<<2,  0,2,64,66, 0,82,                     82,69,83,84>>),
      NBT.Decode.decode(<<3,  0,2,64,67, 0,0,0,82,                 82,69,83,84>>),
      NBT.Decode.decode(<<4,  0,2,64,68, 0,0,0,0,0,0,0,82,         82,69,83,84>>),
      NBT.Decode.decode(<<5,  0,2,64,69, 66,164,0,0,               82,69,83,84>>),
      NBT.Decode.decode(<<6,  0,2,64,70, 64,84,128,0,0,0,0,0,      82,69,83,84>>),
      NBT.Decode.decode(<<7,  0,2,64,71, 0,0,0,5,82,0,65,66,67,    82,69,83,84>>),
      NBT.Decode.decode(<<8,  0,2,64,72, 0,4,82,65,66,67,          82,69,83,84>>),
      NBT.Decode.decode(<<9,  0,2,64,73, 1,0,0,0,2,82,65,          82,69,83,84>>),
      NBT.Decode.decode(<<10, 0,2,64,74, 1,0,2,64,65,82,0,         82,69,83,84>>),
      NBT.Decode.decode(<<11, 0,2,64,75, 0,0,0,2,0,0,0,82,0,0,0,0, 82,69,83,84>>),
    ]
  end

  @filename_plain       "examples/hello_world.nbt"
  @filename_small       "examples/bigtest.nbt"
  @filename_level       "examples/level.dat"
  @filename_player      "examples/player.dat"
  @filename_mineshaft   "examples/mineshaft.dat"
  @filename_chunk       "examples/region.mca.single_chunk.uncompressed"
  @region_file          "examples/region.mca"

  def test_plain do
    @filename_plain
    |> NBT.open
    |> elem(1)
  end

  def test_small do
    @filename_small
    |> NBT.gz_open
    |> elem(1)
  end

  def test_level do
    @filename_level
    |> NBT.gz_open
    |> elem(1)
  end

  def test_player do
    @filename_player
    |> NBT.gz_open
    |> elem(1)
  end

  def test_mineshaft do
    @filename_mineshaft
    |> NBT.gz_open
    |> elem(1)
  end

  def test_chunk do
    @filename_chunk
    |> NBT.open
    |> elem(1)
  end

  # This region file handling will eventually go to its own package.
  def region_file do
    File.read!(@region_file)
  end

  def region_tables_and_data do
    <<
      chunk_table :: binary-unit(8)-size(4_096),
      ts_table :: binary-unit(8)-size(4_096),
      data :: binary
    >> = region_file
    [chunk_table: chunk_table, ts_table: ts_table, data: data]
  end

  def chunk_table_raw do
    table = region_tables_and_data[:chunk_table]
    for <<
      chunk_offset :: big-unsigned-integer-size(3)-unit(8),
      chunk_size :: big-unsigned-integer-size(1)-unit(8)
    <- table>>,
      do: {chunk_offset * 4_096, chunk_size * 4_096}
  end

  def chunk_table do
    chunk_table_raw
    |> Enum.with_index
    |> Enum.sort(fn({{_a_off, a_size}, _a_idx}, {{_b_off, b_size}, _b_idx}) ->
      a_size >= b_size
    end)
    |> Enum.map(fn({{o, s}, i}) -> %{offset: o, size: s, idx: i} end)
    |> Enum.reject(fn(info) -> info.offset == 0 end)
  end

  def chunk do
    chunk_info = hd(chunk_table)
    data = region_tables_and_data[:data]
    offset = chunk_info.offset - 8_192

    <<
      chunk_size :: big-unsigned-integer-size(4)-unit(8),
      compression :: big-unsigned-integer-size(1)-unit(8),
      chunk_data :: binary
    >> = :binary.part(data, offset, chunk_info.size)

    [size: chunk_size, compression: compression, data: chunk_data, offset: chunk_info.offset]
  end

  def uncompressed_chunk do
    chunk[:data]
    |> :binary.part(0, chunk[:size])
    |> :zlib.uncompress
  end

  def decoded_chunk do
    uncompressed_chunk
    |> NBT.Blob.decode("chunk-at-#{chunk[:offset]}")
  end
end
