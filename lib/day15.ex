defmodule Aoc.Day15 do
  @moduledoc """
  Solutions for Day 15.
  """
  @behaviour Aoc.Day

  alias Aoc.Day
  alias Aoc.Utilities.Grid

  @impl Day
  def day(), do: 15

  @impl Day
  def a(map) do
    2_000_000
    |> check_row(map)
  end

  @impl Day
  def b(map) do
    {x, y} = find_beacon(map, 4_000_000)
    4_000_000 * x + y
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      do_parse_input(file)
    end
  end

  def do_parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, &parse_line/2)
    |> Map.new()
  end

  def parse_line(line, map) do
    [sx, sy, bx, by] =
      ~r/x\=(\-?\d+), y\=(\-?\d+).*?x\=(\-?\d+), y\=(\-?\d+)/
      |> Regex.run(line)
      |> tl()
      |> Enum.map(&String.to_integer/1)

    radius = Grid.manhattan({sx, sy}, {bx, by})

    map
    |> Map.put({sx, sy}, radius)
    |> Map.put({bx, by}, "B")
  end

  def check_row(row, map) do
    beacons = Enum.count(get_beacons_in_row(map, row))

    map
    |> Enum.map(&impossible_in_row(&1, row))
    |> Enum.reject(&is_nil/1)
    |> merge_ranges()
    |> Enum.map(&Range.size/1)
    |> Enum.sum()
    |> Kernel.-(beacons)
  end

  def possible_in_row({{x, row}, "B"}, {range, row}) do
    {cut_range(range, x..x), row}
  end

  def possible_in_row({{_, _}, "B"}, acc) do
    acc
  end

  def possible_in_row({{x, y}, radius}, {ranges, row}) do
    distance = abs(y - row)
    range = radius - distance

    if range >= 0 do
      range_to_cut = (x - range)..(x + range)

      {cut_range(ranges, range_to_cut), row}
    else
      {ranges, row}
    end
  end

  def impossible_in_row({{_, _}, "B"}, _) do
    nil
  end

  def impossible_in_row({{x, y}, radius}, row) do
    distance = abs(y - row)
    range = radius - distance

    if range >= 0 do
      (x - range)..(x + range)
    else
      nil
    end
  end

  def is_beacon?({_, "B"}), do: true
  def is_beacon?(_), do: false

  def get_beacons_in_row(map, row) do
    map
    |> Enum.map(fn
      {{_, ^row} = k, "B"} -> k
      _ -> nil
    end)
    |> Enum.reject(&is_nil/1)
  end

  def find_beacon(map, max_y) do
    0..max_y
    |> Enum.reduce_while([], &do_find_beacon(&1, &2, map))
  end

  def do_find_beacon(row, acc, map) do
    case Enum.reduce(map, {[0..4_000_000], row}, &possible_in_row/2) do
      {[x..x], y} -> {:halt, {x, y}}
      _ -> {:cont, acc}
    end
  end

  def merge_ranges([range | ranges] = all_ranges) do
    disjoint_ranges = Enum.filter(ranges, &Range.disjoint?(&1, range))

    joint_ranges = Enum.reject(ranges, &Range.disjoint?(&1, range))

    range = Enum.reduce(joint_ranges, range, &do_merge_ranges/2)

    if [range | disjoint_ranges] == all_ranges do
      all_ranges
    else
      merge_ranges([range | disjoint_ranges])
    end
  end

  def do_merge_ranges(a..b, c..d) do
    min(a, c)..max(b, d)
  end

  def cut_range(ranges, range_to_cut) do
    ranges
    |> Enum.map(&do_cut_range(&1, range_to_cut))
    |> List.flatten()
  end

  def do_cut_range(a..b, c..d) do
    cond do
      a >= c and b <= d -> []
      a < c and b > d -> [a..(c - 1), (d + 1)..b]
      a >= c and a <= d and b > d -> [(d + 1)..b]
      a <= c and b >= c and b < d -> [a..(c - 1)]
      true -> a..b
    end
  end
end
