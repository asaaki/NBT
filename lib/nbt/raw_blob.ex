defmodule NBT.RawBlob do
  @moduledoc false

  alias NBT.{Blob, Decode}

  @empty_blob_data <<10,0,0,0>>

  defstruct name: nil,
            raw: @empty_blob_data,
            data: nil

  def new(raw_data),
    do: new(raw_data, nil)

  def new(raw_data, name),
    do: %__MODULE__{name: name, raw: raw_data}

  def decode(%__MODULE__{} = blob) do
    case is_valid(blob.raw) do
      true -> decode_data(blob)
      _    -> {:error, :nbt_blob_invalid, "Does not start with type Compound"}
    end
  end
  def decode(data),
    do: decode(data, nil)

  def decode(data, path),
    do: data |> new(path) |> decode

  # NOTE: "Every NBT file will always begin with a TAG_Compound. No exceptions." <http://wiki.vg/NBT>
  # Compounds have ID 10.
  def is_valid(<<10, _ :: binary >>),
    do: true
  def is_valid(_),
    do: false

  def decode_data(%{name: name, raw: data}) do
    case maybe_decode_data(data) do
      {:ok, result} ->
        {:ok, %Blob{name: name, data: result}}
      error ->
        error
    end
  end

  defp maybe_decode_data(data) do
    case Decode.decode(data) do
      {data, <<>>} ->
        {:ok, data}
      _ ->
         {:error, {:corrupted_blob, "Data is not exhaustive or has trailing fragments"}}
    end
  end
end
