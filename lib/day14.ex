defmodule Aoc.Day14 do
  @moduledoc """
  Solutions for Day 14.
  """
  @behaviour Aoc.Day

  alias Aoc.Day

  @start {500, 0}
  @impl Day
  def day(), do: 14

  @impl Day
  def a(map) do
    {_.._, _..max_y} =
      map
      |> Map.keys()
      |> get_bounds()

    map = Map.put(map, :void_y, max_y)

    0
    |> Stream.iterate(&(&1 + 1))
    |> Enum.reduce_while(map, &drop_sand/2)
  end

  @impl Day
  def b(map) do
    {_.._, _..max_y} =
      map
      |> Map.keys()
      |> get_bounds()

    map = Map.put(map, :floor, max_y + 2)

    0
    |> Stream.iterate(&(&1 + 1))
    |> Enum.reduce_while(map, &drop_sand/2)
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n", trim: true)
      |> init_map()
    end
  end

  def parse_line(line) do
    line
    |> String.split(~r/\D+/)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
  end

  def init_map(lines, map \\ %{})

  def init_map([], map) do
    map
  end

  def init_map([line | lines], map) do
    map =
      line
      |> parse_line()
      |> draw_lines(map)

    init_map(lines, map)
  end

  def draw_lines([[xa, ya] | [[xb, yb] | _] = lines], map) do
    new_line =
      make_line(xa, ya, xb, yb)
      |> Enum.map(&{&1, "#"})
      |> Map.new()

    draw_lines(lines, Map.merge(map, new_line))
  end

  def draw_lines(_, map) do
    map
  end

  def make_line(x, ya, x, yb) do
    ya..yb
    |> Enum.map(&{x, &1})
  end

  def make_line(xa, y, xb, y) do
    xa..xb
    |> Enum.map(&{&1, y})
  end

  def draw_line(y, range_x, map) do
    range_x
    |> Enum.map(fn x -> Map.get(map, {x, y}, ".") end)
    |> Enum.join()
  end

  def get_bounds(coords) do
    {x, y} = Enum.unzip(coords)
    {Enum.min(x)..Enum.max(x), Enum.min(y)..Enum.max(y)}
  end

  def drop_sand(grain, map) do
    case do_drop_sand(@start, map) do
      :done -> {:halt, grain}
      new_map -> {:cont, new_map}
    end
  end

  def do_drop_sand({_, y} = pos, map) do
    if y < Map.get(map, :void_y) and is_nil(Map.get(map, @start)) do
      pos
      |> drop_possibilities()
      |> Enum.map(&{&1, get_block(map, &1)})
      |> case do
        [{new_pos, nil} | _] -> do_drop_sand(new_pos, map)
        [_, {new_pos, nil}, _] -> do_drop_sand(new_pos, map)
        [_, _, {new_pos, nil}] -> do_drop_sand(new_pos, map)
        _ -> Map.put(map, pos, "o")
      end
    else
      :done
    end
  end

  def drop_possibilities({x, y}) do
    [{x, y + 1}, {x - 1, y + 1}, {x + 1, y + 1}]
  end

  def get_block(%{floor: floor}, {_, y}) when y >= floor do
    "#"
  end

  def get_block(%{} = map, pos) do
    Map.get(map, pos)
  end
end
