defmodule Aoc.Day2 do
  @moduledoc """
  Solutions for Day 2.
  """
  @behaviour Aoc.Day

  alias Aoc.Day

  @impl Day
  def day(), do: 2

  @impl Day
  def a(guide) do
    guide
    |> Enum.map(&score/1)
    |> Enum.sum()
  end

  @impl Day
  def b(guide) do
    guide
    |> Enum.map(&score_b/1)
    |> Enum.sum()
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n", trim: true)
    end
  end

  def score(<<you, _, me>>) do
    do_score(you - 64, me - 87)
  end

  def score_b(<<you, _, me>>) do
    me =
      case me do
        ?X -> (you - 62) |> valid_rps
        ?Y -> you - 64
        ?Z -> (you - 63) |> valid_rps
      end

    IO.inspect(me)

    do_score(you - 64, me)
  end

  defp do_score(you, you) do
    you + 3
  end

  defp do_score(you, me) do
    case me - you do
      1 -> me + 6
      -2 -> me + 6
      _ -> me
    end
  end

  defp valid_rps(selection) do
    Stream.cycle([1, 2, 3]) |> Enum.at(selection - 1)
  end
end
