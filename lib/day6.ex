defmodule Aoc.Day6 do
  @moduledoc """
  Solutions for Day 6.
  """
  @behaviour Aoc.Day

  alias Aoc.Day

  @impl Day
  def day(), do: 6

  @impl Day
  def a(signal) do
    parse(signal, 4)
  end

  @impl Day
  def b(signal) do
    parse(signal, 14)
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      String.split(file, "", trim: true)
    end
  end

  def parse(list, size) do
    parse(list, size, size)
  end

  def parse([_ | rest] = list, size, count) do
    list
    |> Enum.take(size)
    |> Enum.uniq()
    |> Enum.count()
    |> case do
      ^size -> count
      _ -> parse(rest, size, count + 1)
    end
  end

  def parse(_, _, count) do
    count
  end
end
