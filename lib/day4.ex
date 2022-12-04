defmodule Aoc.Day4 do
  @moduledoc """
  Solutions for Day 4.
  """
  @behaviour Aoc.Day

  alias Aoc.{Bingo, Day}
  alias Aoc.Bingo.Card

  @impl Day
  def day(), do: 4

  @impl Day
  def a(sections) do
    sections
    |> Enum.filter(fn [a, b] -> MapSet.subset?(a, b) or MapSet.subset?(b, a) end)
    |> Enum.count()
  end

  @impl Day
  def b(sections) do
    sections
    |> Enum.reject(fn [a, b] -> MapSet.disjoint?(a, b) end)
    |> Enum.count()
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_line/1)
    end
  end

  def parse_line(line) do
    ~r/(\d+)\-(\d+),(\d+)\-(\d+)/
    |> Regex.run(line)
    |> tl()
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.map(&make_mapset/1)
  end

  def make_mapset([low, high]) do
    low
    |> Range.new(high)
    |> MapSet.new()
  end
end
