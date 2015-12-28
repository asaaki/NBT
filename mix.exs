defmodule NBT.Mixfile do
  use Mix.Project

  @version "0.1.0-dev99"

  def project do
    [
      app: :nbt,
      version: @version,
      elixir: "~> 1.1",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps
    ]
  end

  def application do
    [
      applications: [:logger]
    ]
  end

  defp deps do
    [
      {:benchfella, "~> 0.3", only: [:dev, :test, :bench, :prod]}
    ]
  end
end
