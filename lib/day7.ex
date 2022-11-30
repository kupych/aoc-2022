defmodule Aoc.Day7 do
  @moduledoc """
  Solutions for Day 7.
  """
  @behaviour Aoc.Day

  alias Aoc.Day

  @impl Day
  def day(), do: 7

  @impl Day
  def a(positions) do
    [{_, min_fuel} | _] =
      Enum.min(positions)..Enum.max(positions)
      |> Enum.map(&calculate_fuel(&1, positions))
      |> Enum.sort_by(&elem(&1, 1))

    min_fuel
  end

  @impl Day
  def b(positions) do
    [{_, min_fuel} | _] =
      Enum.min(positions)..Enum.max(positions)
      |> Enum.map(&calculate_fuel_cumulative(&1, positions))
      |> Enum.sort_by(&elem(&1, 1))

    min_fuel
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split(~r/\D/, trim: true)
      |> Enum.map(&String.to_integer/1)
    end
  end

  def calculate_fuel(position, positions) do
    differences =
      positions
      |> Enum.map(&Kernel.abs(position - &1))
      |> Enum.sum()

    {position, differences}
  end

  def calculate_fuel_cumulative(position, positions) do
    differences =
      positions
      |> Enum.map(&Kernel.abs(position - &1))
      |> Enum.map(&Enum.sum(0..&1))
      |> Enum.sum()

    {position, differences}
  end
end
