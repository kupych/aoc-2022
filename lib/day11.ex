defmodule Aoc.Day11 do
  @moduledoc """
  Solutions for Day 11.
  """
  @behaviour Aoc.Day

  alias Aoc.{Day, Utilities}

  @impl Day
  def day(), do: 11

  @impl Day
  def a(grid) do
    {grid, flashes} = Enum.reduce(1..100, grid, &day(&1, &2, false))
    flashes
  end

  @impl Day
  def b(grid) do

    total = Enum.count(coordinates(grid))

    Enum.reduce_while(1..900, grid, fn x, acc ->
      case day(x, acc, true) do
        {_, ^total} -> {:halt, x}
        grid -> {:cont, grid}
      end
    end)

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

  def day(_, {grid, flashes}, reset?) do
    grid = increase(grid)

    ready_to_flash =
      grid
      |> coordinates()
      |> Enum.filter(&ready_to_flash?(&1, grid))

    flash(grid, ready_to_flash, (if reset?, do: 0, else: flashes))
  end

  def day(_, grid, reset?) do
    day(0, {grid, 0}, reset?)
  end

  def increase(grid) do
    grid
    |> Tuple.to_list()
    |> Enum.map(&increase_row/1)
    |> List.to_tuple()
  end

  def increase_row(row) do
    row
    |> Tuple.to_list()
    |> Enum.map(&Kernel.+(&1, 1))
    |> List.to_tuple()
  end

  def value_at({x, y}, grid)
      when x < 0 or y < 0 or x >= tuple_size(elem(grid, 0)) or y >= tuple_size(grid) do
    0
  end

  def value_at({x, y}, grid) do
    grid
    |> elem(y)
    |> elem(x)
  end

  def ready_to_flash?({x, y}, grid) do
    value_at({x, y}, grid) > 9
  end

  def flash(grid, coords, flashes \\ 0)
  def flash(grid, [], flashes) do
    {grid, flashes}
  end

  def flash(grid, [coord | rest], flashes) do
    case value_at(coord, grid) do
      value when value >= 9 ->
        flash(update_value(coord, grid, 0), rest ++ neighbours(coord), flashes + 1)

      0 ->
        flash(grid, rest, flashes)

      value ->
        flash(update_value(coord, grid, value + 1), rest, flashes)
    end
  end

  def neighbours({x, y}) do
    [
      {x, y - 1},
      {x, y + 1},
      {x - 1, y},
      {x + 1, y},
      {x - 1, y - 1},
      {x - 1, y + 1},
      {x + 1, y - 1},
      {x + 1, y + 1}
    ]
  end

  def print_grid(grid) do
    grid
    |> Tuple.to_list()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.join("\n")
    |> IO.puts()
  end

  def coordinates(grid) do
    x = tuple_size(elem(grid, 0)) - 1
    y = tuple_size(grid) - 1

    for y <- 0..y, x <- 0..x do
      {x, y}
    end
  end

  def update_value({x, y}, grid, value) do
    row =
      grid
      |> elem(y)
      |> put_elem(x, value)

    put_elem(grid, y, row)
  end
end
