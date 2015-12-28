defmodule NBT.Types do
  @moduledoc """
  Types
  """

  @nbt_types ~w(Byte Short Int Long Float Double ByteArray String List Compound IntArray)a

  @doc false
  def from_id(type_id)
  for {type_name, idx} <- Enum.with_index(@nbt_types) do
    mod_name = Module.concat(__MODULE__, type_name)
    type_id = idx + 1
    def from_id(unquote(type_id)), do: unquote(mod_name)
  end

  @doc false
  def to_id(module_atom)
  for {type_name, idx} <- Enum.with_index(@nbt_types) do
    mod_name = Module.concat(__MODULE__, type_name)
    type_id = idx + 1
    def to_id(unquote(mod_name)), do: unquote(type_id)
  end
end
