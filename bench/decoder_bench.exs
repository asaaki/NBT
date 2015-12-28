defmodule DecoderBench do
  use Benchfella

  @filename_plain       "examples/hello_world.nbt"
  @filename_small       "examples/bigtest.nbt"
  @filename_level       "examples/level.dat"
  @filename_player      "examples/player.dat"
  @filename_mineshaft   "examples/mineshaft.dat"
  @filename_chunk       "examples/region.mca.single_chunk.uncompressed"

  @empty_compound       <<10, 0, 0, 0>> # type 10, zero length name, no entries
  @file_plain           File.read!(@filename_plain)
  @file_small           File.read!(@filename_small) |> :zlib.gunzip
  @file_level           File.read!(@filename_level) |> :zlib.gunzip
  @file_player          File.read!(@filename_player) |> :zlib.gunzip
  @file_mineshaft       File.read!(@filename_mineshaft) |> :zlib.gunzip
  @file_chunk           File.read!(@filename_chunk)

  bench "NBT             (empty compound)", do: NBT.decode(@empty_compound)
  bench "nbt_erlang      (empty compound)", do: :nbt_erlang.parse_data(@empty_compound)

  bench "NBT                       (tiny)", do: NBT.decode(@file_plain)
  bench "nbt_erlang                (tiny)", do: :nbt_erlang.parse_data(@file_plain)

  bench "NBT                      (small)", do: NBT.decode(@file_small)
  bench "nbt_erlang               (small)", do: :nbt_erlang.parse_data(@file_small)

  bench "NBT                  (level.dat)", do: NBT.decode(@file_level)
  bench "nbt_erlang           (level.dat)", do: :nbt_erlang.parse_data(@file_level)

  bench "NBT                 (player.dat)", do: NBT.decode(@file_player)
  bench "nbt_erlang          (player.dat)", do: :nbt_erlang.parse_data(@file_player)

  bench "NBT              (mineshaft.dat)", do: NBT.decode(@file_mineshaft)
  bench "nbt_erlang       (mineshaft.dat)", do: :nbt_erlang.parse_data(@file_mineshaft)

  bench "NBT          (region chunk data)", do: NBT.decode(@file_chunk)
  bench "nbt_erlang   (region chunk data)", do: :nbt_erlang.parse_data(@file_chunk)
end
