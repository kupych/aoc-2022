defmodule Aoc.Day13 do
  @moduledoc """
  Solutions for Day 13.
  """
  @behaviour Aoc.Day

  alias Aoc.Day

  @impl Day
  def day(), do: 13

  @divider_packets [[[2]], [[6]]] 
  @impl Day
  def a(pairs) do
    pairs
    |> Enum.chunk_every(2)
    |> Enum.with_index(1)
    |> Enum.filter(fn {x, _} -> sorted?(x) end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  @impl Day
  def b(lines) do
    lines
    |> Enum.concat(@divider_packets)
    |> Enum.sort(&compare_values(&1, &2) > 0)
    |> Enum.with_index(1)
    |> Map.new()
    |> Map.take(@divider_packets)
    |> Map.values()
    |> Enum.product()
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&Jason.decode!/1)
    end
  end

  def sorted?([left, right]) do
    compare_values(left, right) > 0
  end

  def compare_values([a | left], [b | right]) when is_list(a) and is_integer(b) do
    compare_values([a | left], [[b] | right])
  end

  def compare_values([a | left], [b | right]) when is_integer(a) and is_list(b) do
    compare_values([[a] | left], [b | right])
  end

  def compare_values([a | left], [a | right]) when is_integer(a) do
    compare_values(left, right)
  end
  def compare_values([a | _], [b | _]) when is_integer(a) and is_integer(b) do
    b - a
  end

  def compare_values([], []) do
    0
  end

  def compare_values([], [_ | _]) do
    1 
  end

  def compare_values([_ | _], []) do
    -1
  end

  def compare_values([a | left], [b | right]) when is_list(a) and is_list(b) do
    case compare_values(a, b) do
      0 -> compare_values(left, right)
      diff -> diff
    end
  end

end
