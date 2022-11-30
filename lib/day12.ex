defmodule Aoc.Day12 do
  @moduledoc """
  Solutions for Day 12.
  """
  @behaviour Aoc.Day

  alias Aoc.Day

  @impl Day
  def day(), do: 12

  @impl Day
  def a(paths) do
    find_paths("start", paths)
  end

  @impl Day
  def b(paths) do
    find_paths("start", paths, [], true)
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      do_parse_input(file)
    end
  end

  def do_parse_input(file) do
    file
    |> String.split(~r/\W+/, trim: true)
    |> Enum.chunk_every(2)
    |> Enum.reduce(%{}, &build_paths/2)
  end

  def build_paths([start_node, end_node], connections) do
    connections
    |> Map.update(start_node, [end_node], &[end_node | &1])
    |> Map.update(end_node, [start_node], &[start_node | &1])
  end

  def find_paths(cave, paths, visited \\ [], visit_twice? \\ false, twice \\ nil)

  def find_paths("end", _, _, _, _) do
    1
  end

  def find_paths("start", _, [_ | _], _, _) do
    0
  end

  def find_paths(cave, paths, visited, visit_twice?, twice) do
    with true <- small_cave?(cave),
         true <- Enum.member?(visited, cave) and (!visit_twice? or is_binary(twice)) do
      0
    else
      _ ->
        twice = if visit_twice? do
          maybe_visit_twice(twice, cave, visited)
        else
          nil
        end

        paths
        |> Map.get(cave, [])
        |> Enum.map(&find_paths(&1, paths, [cave | visited], visit_twice?, twice))
        |> Enum.sum()
    end
  end

  def small_cave?(<<c, _::binary>>) when c >= ?a, do: true
  def small_cave?(_), do: false

  def maybe_visit_twice(twice, cave, visited) do
    with true <- small_cave?(cave),
         true <- Enum.member?(visited, cave) do
      cave
    else
      _ -> twice
    end
  end
end
