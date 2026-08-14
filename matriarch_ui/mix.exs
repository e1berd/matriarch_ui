defmodule MatriarchUI.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/e1berd/matriarch_ui"

  def project do
    [
      app: :matriarch_ui,
      version: @version,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      compilers: [:phoenix_live_view] ++ Mix.compilers(),
      deps: deps(),
      description: "A Phoenix LiveView component kit with polished Mosaic-inspired primitives.",
      package: package(),
      docs: docs()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:phoenix_live_view, "~> 1.2"},
      {:phoenix_html, "~> 4.3"},
      {:phosphor_icons, "~> 2.1", compile: false, app: false},
      {:ex_doc, "~> 0.40", only: :dev, runtime: false},
      {:lazy_html, ">= 0.1.0", only: :test},
      {:jason, "~> 1.4"}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url},
      files: ~w(lib assets priv .formatter.exs mix.exs README.md LICENSE)
    ]
  end

  defp docs do
    [
      main: "readme",
      source_ref: "v#{@version}",
      source_url: @source_url,
      extras: ["README.md"]
    ]
  end
end
