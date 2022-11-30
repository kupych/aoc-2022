defmodule Aoc.Day6 do
  @moduledoc """
  Solutions for Day 6.
  """
  @behaviour Aoc.Day

  alias Aoc.Day

  @impl Day
  def day(), do: 6

  @impl Day
  def a(fish) do
    1..80
    |> Enum.reduce(fish, &fish_day/2)
    |> Map.values()
    |> Enum.sum()
  end

  @impl Day
  def b(fish) do
    1..256
    |> Enum.reduce(fish, &fish_day/2)
    |> Map.values()
    |> Enum.sum()
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      frequencies =
        file
        |> String.trim()
        |> String.split(",", trim: true)
        |> Enum.map(&String.to_integer/1)
        |> Enum.frequencies()

      0..8
      |> Enum.map(&{&1, 0})
      |> Map.new()
      |> Map.merge(frequencies)
    end
  end

  def fish_day(_, fish) do
    %{
      0 => zero,
      1 => one,
      2 => two,
      3 => three,
      4 => four,
      5 => five,
      6 => six,
      7 => seven,
      8 => eight
    } = fish

    %{
      0 => one,
      1 => two,
      2 => three,
      3 => four,
      4 => five,
      5 => six,
      6 => zero + seven, #aging fish + restarting age countdown
      7 => eight,
      8 => zero
    }
  end
end
