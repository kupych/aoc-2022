defmodule Aoc.Day1 do
  @moduledoc """
  Solutions for Day 1.
  """
  @behaviour Aoc.Day

  alias Aoc.Day

  @impl Day
  def day(), do: 1

  @impl Day
  def a(calories) do
    calories
    |> Enum.map(&Enum.sum/1)
    |> Enum.sort(&(&1 >= &2))
    |> hd()
  end

  @impl Day
  def b(calories) do
    calories
    |> Enum.map(&Enum.sum/1)
    |> Enum.sort(&(&1 >= &2))
    |> Enum.take(3)
    |> Enum.sum()
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.trim()
      |> String.split("\n\n", trim: true)
      |> Enum.map(&parse_calorie_count/1)
    end
  end

  defp parse_calorie_count(calories) when is_binary(calories) do
    calories
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
