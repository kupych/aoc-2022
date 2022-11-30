defmodule Aoc.Day9 do
  @moduledoc """
  Solutions for Day 9.
  """
  @behaviour Aoc.Day

  alias Aoc.{Day, Utilities}

  @impl Day
  def day(), do: 9

  @impl Day
  def a(grid) do
    grid
    |> coordinates()
    |> Enum.filter(&low_point?(&1, grid))
    |> Enum.map(&(value_at(&1, grid) + 1))
    |> Enum.sum()
  end

  @impl Day
  def b(grid) do
    grid
    |> coordinates()
    |> Enum.filter(&low_point?(&1, grid))
    |> Enum.map(&basin_size(grid, [&1]))
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&Utilities.binary_to_digits/1)
      |> List.to_tuple()
    end
  end

  def low_point?({_, _} = coord, grid) do
    neighbours =
      neighbours(coord)
      |> Enum.map(&value_at(&1, grid))

    value = value_at(coord, grid)

    Enum.all?(neighbours, &(&1 > value))
  end

  def basin_size(grid, coords, size \\ 0, visited \\ MapSet.new())

  def basin_size(_, [], size, _) do
    size
  end

  def basin_size(grid, [coord | rest], size, visited) do
    cond do
      # Coordinate already visited, ignore
      MapSet.member?(visited, coord) ->
        basin_size(grid, rest, size, visited)

      # Border of the basin
      value_at(coord, grid) >= 9 ->
        basin_size(grid, rest, size, MapSet.put(visited, coord))

      # Add neighbours to the list of coordinates and increase size
      true ->
        basin_size(grid, rest ++ neighbours(coord), size + 1, MapSet.put(visited, coord))
    end
  end

  def neighbours({x, y}) do
    [{x, y - 1}, {x, y + 1}, {x - 1, y}, {x + 1, y}]
  end

  # Instead of worrying about checking for overflowing the bounds of
  # the grid, we can just return the highest possible value, in 
  # this case 9.
  def value_at({x, y}, grid)
      when x < 0 or y < 0 or x >= tuple_size(elem(grid, 0)) or y >= tuple_size(grid) do
    9
  end

  def value_at({x, y}, grid) do
    grid
    |> elem(y)
    |> elem(x)
  end

  def coordinates(grid) do
    x = tuple_size(elem(grid, 0)) - 1
    y = tuple_size(grid) - 1

    for y <- 0..y, x <- 0..x do
      {x, y}
    end
  end
end
