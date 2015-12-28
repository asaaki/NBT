defmodule NBT.Decodable do

  def to_state(ctx, data, named) do
    {ctx, data, named}
  end

  def add_name({ctx, data, false = named}),
    do: {ctx, data, named}
  def add_name({
    ctx,
    <<len :: big-unsigned-integer-size(16),
    name :: binary-size(len),
    data :: binary>>,
    named
  }) do
    {struct(ctx, name: name), data, named}
  end
end
