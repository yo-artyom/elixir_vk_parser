defmodule VkParser.Mixfile do
  use Mix.Project

  def project do
    [
      app: :vk_parser,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :httpotion],
      mod: {VkParser, []}
    ]
  end

  defp deps do
    [
      {:httpotion, "~> 3.0.2"},
      {:poison, "~> 3.1"},
      {:gen_stage, "~> 0.12"},
      {:balalaika_bear, "~> 0.1.2"},
      {:csv, "~> 2.0.0"},
      {:statistics, "~> 0.5.0"},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false}
    ]
  end
end
