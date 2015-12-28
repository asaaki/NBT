# NBT

> _Named Binary Tag_

NBT (Named Binary Tag) library in Elixir.

NBT is a data format used in the sandbox game Minecraft.

Format specification: <http://wiki.vg/NBT>

My previous attempt in Erlang at <https://github.com/asaaki/eNBT> (a copy for the benchmark resides here, too).

## Info

**This library is just for fun.**
I don't think one would really consider rebuilding Minecraft in Elixir/Erlang. (Although …)

## Benchmark

Unfair comparison with my old pure Erlang implementation (https://github.com/asaaki/eNBT),
because the Erlang code uses simple tuples only.

```
## DecoderBench
nbt_erlang      (empty compound)    10000000      0.61 µs/op
NBT             (empty compound)    10000000      0.90 µs/op
nbt_erlang                (tiny)    10000000      1.01 µs/op
NBT                       (tiny)    10000000      1.71 µs/op
nbt_erlang               (small)     1000000     13.88 µs/op
NBT                      (small)      500000     18.33 µs/op
nbt_erlang          (player.dat)      500000     31.15 µs/op
NBT                 (player.dat)      100000     50.93 µs/op
nbt_erlang           (level.dat)      100000     56.26 µs/op
NBT                  (level.dat)      100000     87.07 µs/op
NBT          (region chunk data)      100000     90.76 µs/op
nbt_erlang   (region chunk data)       50000    253.82 µs/op
nbt_erlang       (mineshaft.dat)        5000   1561.18 µs/op
NBT              (mineshaft.dat)        5000   2112.74 µs/op
```

The empty unnamed compound is the simplest and smallest valid blob you can have.

The mineshaft data is pretty compound and list heavy, but 2 ms seems to be still acceptable.

As you can see, for _real world_ data like chunks the Elixir decoder is much better at it:

```
NBT          (region chunk data)      100000     90.76 µs/op
nbt_erlang   (region chunk data)       50000    253.82 µs/op

Almost 3 times faster. Woah!
```

Since this is the most common data structure you would have to decode, I call this a big win.

## Conclusion

Most of the overhead for the smaller blobs is probably just because of the Elixir structs.
If I would have used tuples for storage and empty module names as markers for the protocol based decoder the performance
might be identical to the Erlang code.

Fascinating was the parsing/decoding process entirely driven by protocols and a couple of lines for dispatching
instead of a single huge parser file (as you can see in the Erlang version).

## TODOs

- [x] Decode
- [ ] Encode
- [ ] Tests
- [ ] A real use case
