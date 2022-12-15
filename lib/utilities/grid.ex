defmodule Aoc.Utilities.Grid do
  @moduledoc """
  Defines a series of utility functions to generate a grid of values from 
  a string input.
  """

  @cardinal [{-1, 0}, {1, 0}, {0, 1}, {0, -1}]
  @diagonal [{-1, -1}, {-1, 1}, {1, -1}, {1, 1}]

  @doc """
  `new/1` takes an input of a grid of characters,
  separating them by one or more separator characters, and returns it as a
  map of coordinates and values.

  ## Examples
      iex> grid = "ab\ncd"
      iex> Aoc.Utilities.Grid.new(grid)
      %{
        {0, 0} => "a",
        {1, 0} => "b",
        {0, 1} => "c",
        {1, 1} => "d",
      }
  """
  @spec new(input :: binary, options :: keyword) :: map
  def new(input, options \\ []) when is_binary(input) do
    [x_sep, y_sep] = Keyword.get(options, :separators, ["", "\n"])
    function = Keyword.get(options, :fn, & &1)

    input
    |> String.split(x_sep, trim: true)
    |> Enum.chunk_by(&(&1 == y_sep))
    |> Enum.reject(&(&1 == [y_sep]))
    |> Enum.map(&Enum.with_index/1)
    |> Enum.with_index()
    |> Enum.reduce([], &list_to_map/2)
    |> Enum.map(fn {k, v} -> {k, function.(v)} end)
    |> Map.new()
  end

  def bounds(%{} = grid) do
    {x, y} =
      grid
      |> Map.keys()
      |> Enum.unzip()

    {Enum.min(x)..Enum.max(x), Enum.min(y)..Enum.max(y)}
  end

  defp list_to_map({row, y}, grid) do
    row
    |> Enum.map(fn {v, x} -> {{x, y}, v} end)
    |> Enum.concat(grid)
  end

  def print(%{} = grid) do
    {bounds_x, bounds_y} = bounds(grid) |> IO.inspect()

    bounds_y
    |> Enum.map(fn y ->
      bounds_x
      |> Enum.map(&Map.get(grid, {&1, y}, " "))
      |> Enum.join()
    end)
    |> Enum.join("\n")
    |> IO.puts()
  end

  def neighbors(pos, grid, diagonal? \\ false) do
    diagonal = if diagonal?, do: @diagonal, else: []

    @cardinal
    |> Enum.concat(diagonal)
    |> Enum.map(&add_coords(pos, &1))
    |> Enum.map(&Map.get(grid, &1))
  end

  def add_coords({xa, ya}, {xb, yb}), do: {xa + xb, ya + yb}

  def manhattan({xa, ya}, {xb, yb}) do
    abs(xa-xb) + abs(ya-yb)
  end
end
