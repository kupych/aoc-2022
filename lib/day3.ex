defmodule Aoc.Day3 do
  @moduledoc """
  Solutions for Day 3.
  """
  @behaviour Aoc.Day

  alias Aoc.Day

  @impl Day
  def day(), do: 3

  @impl Day
  def a(rucksacks) do
    rucksacks
    |> Enum.map(&parse_a/1)
    |> Enum.map(&apply(MapSet, :intersection, &1))
    |> Enum.map(&ascii_to_priority/1)
    |> Enum.sum()
  end

  @impl Day
  def b(rucksacks) do
    rucksacks
    |> Enum.chunk_every(3)
    |> Enum.map(&parse_b/1)
    |> Enum.sum()
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_charlist/1)
    end
  end

  def parse_a(rucksack) do
    rucksack
    |> Enum.chunk_every(trunc(length(rucksack) / 2))
    |> Enum.map(&MapSet.new/1)
  end

  def parse_b(rucksacks) do
    [a, b, c] = Enum.map(rucksacks, &MapSet.new/1)

    a
    |> MapSet.intersection(b)
    |> MapSet.intersection(c)
    |> ascii_to_priority()
  end

  def ascii_to_priority(mapset) do
    mapset
    |> MapSet.to_list()
    |> hd()
    |> do_ascii_to_priority()
  end

  def do_ascii_to_priority(ascii) when ascii >= 97, do: ascii - 96
  def do_ascii_to_priority(ascii), do: ascii - 38
end
