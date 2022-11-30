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
  def a(bingo_game) do
    Bingo.call(bingo_game, :win)
  end

  @impl Day
  def b(bingo_game) do
    Bingo.call(bingo_game, :lose)
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      [numbers | cards] = String.split(file, "\n\n", trim: true)

      numbers =
        numbers
        |> String.split(",", trim: true)
        |> Enum.map(&String.to_integer/1)

      %{numbers: numbers, cards: Enum.map(cards, &Card.new/1)}
    end
  end
end
