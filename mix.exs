defmodule NBT.Mixfile do
  use Mix.Project

  @version "0.1.0-dev99"

  def project do
    [
      app: :nbt,
      version: @version,
      elixir: "~> 1.2",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps
    ]
  end

  def application, do: []

  defp deps do
    [
      {:credo, "~> 0.3", only: [:lint, :ci]},
      {:ex_doc, "~> 0.11", only: [:docs, :ci]},
      {:cmark, "~> 0.6", only: [:docs, :ci]},
      {:inch_ex, "~> 0.5", only: [:docs, :ci]},
      {:excoveralls, "~> 0.5", only: [:ci]},
      {:benchfella, "~> 0.3", only: [:dev, :test, :bench, :prod]},
    ]
  end
end
