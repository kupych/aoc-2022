defmodule Aoc.Day12 do
  @moduledoc """
  Solutions for Day 12.
  """
  @behaviour Aoc.Day

  alias Aoc.Day
  alias Aoc.Utilities.Grid

  @impl Day
  def day(), do: 12

  @impl Day
  def a(mountain) do
    #    end_pos = {mountain.path_end, mountain[mountain.path_end]}

    #IO.inspect(step(end_pos, [%{steps: 0, visited: MapSet.new([mountain.path_end])}], mountain))
    :ok
  end

  @impl Day
  def b(_) do
    :ok
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      do_parse_input(file)
    end
  end

  def do_parse_input(input) do
    Grid.new(input, fn: &get_energy_level/1)
  end

  def map_grid(?\n, {{x, y} = pos, map}) do
    {{0, y + 1}, map}
  end

  def map_grid(?S, {{x, y} = pos, map}) do
    map =
      map
      |> Map.merge(%{pos => ?a, :path_start => pos})
      |> then(&{{x + 1, y}, &1})
  end

  def map_grid(?E, {{x, y} = pos, map}) do
    map =
      map
      |> Map.merge(%{pos => ?z, :path_end => pos})
      |> then(&{{x + 1, y}, &1})
  end

  def map_grid(height, {{x, y} = pos, map}) do
    {{x + 1, y}, Map.put(map, pos, height)}
  end

  def neighbors(pos, mountain) do
    Map.take(mountain, neighboring_squares(pos))
  end

  def can_step?({_, dest}, current) when dest - current < -1 do
    false
  end

  def can_step?(_, _) do
    true
  end

  def step(
        {pos, height},
        [%{steps: steps, visited: visited} = path | rest] = paths,
        %{path_start: path_start} = mountain
      ) do
    case pos do
      ^path_start ->
        List.flatten([path | rest])

      pos ->
        neighbors =
          pos
          |> neighbors(mountain)
          |> Enum.reject(&visited?(&1, visited))
          |> Enum.filter(&can_step?(&1, height))
          |> Map.new()
          |> IO.inspect()

        visited = Enum.reduce(neighbors, path.visited, fn {k, _}, acc -> MapSet.put(acc, k) end)
        path = Map.merge(path, %{steps: steps + 1, visited: visited})

        neighbors
        |> Enum.map(fn {k, v} = x -> step(x, [path | rest], mountain) end)
        |> List.flatten()
    end
  end

  def visited?({pos, _}, visited) do
    pos in visited
  end

  def neighboring_squares({x, y}) do
    [
      {x - 1, y},
      {x + 1, y},
      {x, y - 1},
      {x, y + 1}
    ]
  end

  def get_energy_level("S"), do: 0
  def get_energy_level("E"), do: 27
  def get_energy_level(<<c>>), do: c - 96
end
