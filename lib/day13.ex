defmodule Aoc.Day13 do
  @moduledoc """
  Solutions for Day 13.
  """
  @behaviour Aoc.Day

  alias Aoc.Day

  @impl Day
  def day(), do: 13

  @impl Day
  def a(%{coords: coords, instructions: [instruction | _]}) do
    instruction
    |> fold(coords)
    |> Enum.count()
  end

  @impl Day
  def b(%{coords: coords, instructions: instructions}) do
    string = instructions
    |> Enum.reduce(coords, &fold/2)
    |> draw()

    "\n" <> string
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      do_parse_input(file)
    end
  end

  def do_parse_input(file) do
    [coords, instructions] =
      file
      |> String.split("\n\n", trim: true)

    %{coords: parse_coords(coords), instructions: String.split(instructions, "\n", trim: true)}
  end

  def parse_coords(coord_string) do
    coord_string
    |> String.split("\n", trim: true)
    |> Enum.map(&do_parse_coord/1)
  end

  def do_parse_coord(coord) do
    coord
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def fold("fold along " <> fold, coords) do
    [dir, fold] =
      fold
      |> String.split("=")

    fold = String.to_integer(fold)

    coords
    |> Enum.map(&maybe_fold(&1, dir, fold))
    |> Enum.uniq()
  end

  def maybe_fold({x, y}, "x", fold) when x > fold do
    {fold_at(x, fold), y}
  end

  def maybe_fold({x, y}, "y", fold) when y > fold do
    {x, fold_at(y, fold)}
  end

  def maybe_fold(coord, _, _) do
    coord
  end

  def fold_at(value, fold) do
    value - 2 * (value - fold)
  end

  def draw(pixels) do
    {x, y} = Enum.unzip(pixels)
    max_x = Enum.max(x)
    max_y = Enum.max(y)

    for y <- 0..max_y do
      for x <- 0..max_x do
        if Enum.member?(pixels, {x, y}) do
          "█"
        else
          " "
        end
      end
    end
    |> Enum.map(&Enum.join/1)
    |> Enum.join("\n")
  end
end
