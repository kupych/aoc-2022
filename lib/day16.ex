defmodule Aoc.Day16 do
  @moduledoc """
  Solutions for Day 16.
  """
  @behaviour Aoc.Day

  alias Aoc.Day

  @impl Day
  def day(), do: 16

  @impl Day
  def a(valves) do
    IO.inspect valves
    :ok
  end

  @impl Day
  def b(_) do
    ""
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      graph = :digraph.new()

        file
        |> String.split("\n", trim: true)
        |> Enum.reduce({%{}, graph}, &parse_valve/2)
    end
  end

  def parse_valve(string, {map, graph}) do
    [_, valve, rate, tunnels] = Regex.run(~r/Valve ([A-Z]{2}).*?(\d+).*?valves? (.*)/, string)

    :digraph.add_vertex(graph, valve)
    tunnels = String.split(tunnels, ", ")

    Enum.each(tunnels, &:digraph.add_vertex(graph, &1))
    tunnels
      |> Enum.map(&[graph, valve, &1])
      |> Enum.each(&apply(:digraph, :add_edge, &1))

    {Map.put(map, valve, String.to_integer(rate)), graph}
  end

  def open_valves(valves, visited \\ ["AA"])

  def open_valves(_, path) when length(path) == 30 do
    path
  end

  def open_valves(valves, [current | visited] = path) do
    valves
    |> get_in([current, :tunnels])
    |> Kernel.--(visited)
    |> case do
      [] -> path
      tunnels -> Enum.map(tunnels, &open_valves(valves, [&1 | path]))
    end
  end
end
