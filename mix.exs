defmodule UeberauthAuthy.Mixfile do
  use Mix.Project

  def project do
    [app: :ueberauth_authy,
     version: "0.1.0",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:ueberauth, :authy, :logger]]
  end

  defp deps do
    [{:ueberauth, "~> 0.2.0"},
     {:authy, github: "365assistance/authy", tag: "0.2.0"}]
  end
end
