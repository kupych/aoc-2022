defmodule Aoc.Day5 do
  @moduledoc """
  Solutions for Day 5.
  """
  @behaviour Aoc.Day

  alias Aoc.Day

  @impl Day
  def day(), do: 5

  @impl Day
  def a(lines) do
    lines
    |> Enum.filter(&straight_line?/1)
    |> Enum.flat_map(&calculate_line/1)
    |> Enum.frequencies()
    |> Enum.count(fn {_, v} -> v > 1 end)
  end

  @impl Day
  def b(lines) do
    lines
    |> Enum.flat_map(&calculate_line/1)
    |> Enum.frequencies()
    |> Enum.count(fn {_, v} -> v > 1 end)
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split(~r/\D+/, trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(4)
    end
  end

  def straight_line?([x, _, x, _]), do: true
  def straight_line?([_, y, _, y]), do: true
  def straight_line?(_), do: false

  def calculate_line([x, ya, x, yb]) do
    yrange = ya..yb
    xlist = List.duplicate(x, Range.size(yrange))
    Enum.zip(xlist, yrange)
  end

  def calculate_line([xa, y, xb, y]) do
    xrange = xa..xb
    ylist = List.duplicate(y, Range.size(xrange))
    Enum.zip(xrange, ylist)
  end

  def calculate_line([xa, ya, xb, yb]) when abs(xa - xb) == abs(ya - yb) do
    Enum.zip(xa..xb, ya..yb)
  end

  def calculate_line(_) do
    []
  end
end
