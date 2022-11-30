defmodule Aoc.Bingo.Card do
  @moduledoc """
  A struct for the bingo cards in 2021 Day 4.
  """
  alias Aoc.Bingo.Cell
  alias Aoc.Utilities
  alias __MODULE__

  defstruct cells: []

  def new(numbers) do
    cells =
      numbers
      |> String.split(~r/\s+/, trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.map(&Cell.new/1)

    %Card{cells: cells}
  end

  def score(%Card{cells: cells}) do
    cells
    |> Enum.reject(& &1.marked?)
    |> Enum.map(& &1.value)
    |> Enum.sum()
  end

  def mark(%Card{cells: cells} = card, value) when is_integer(value) do
    cells =
      Enum.map(cells, fn
        %{value: ^value} = matching_cell -> Cell.mark(matching_cell)
        cell -> cell
      end)

    %{card | cells: cells}
  end

  def winning?(%Card{cells: cells}) do
    markings =
      cells
      |> Enum.map(& &1.marked?)
      |> Enum.chunk_every(5)

    winning_row = Enum.find_index(markings, &Enum.all?(&1))

    winning_column =
      markings
      |> Utilities.transpose()
      |> Enum.find_index(&Enum.all?(&1))

    is_integer(winning_row) or is_integer(winning_column)
  end
end

defmodule Aoc.Bingo.Cell do
  @moduledoc """
  A struct for the bingo card cells in 2021 Day 4.
  """
  alias __MODULE__

  defstruct value: 0, marked?: false

  def new(value) do
    %Cell{value: value, marked?: false}
  end

  def mark(%__MODULE__{} = cell) do
    Map.put(cell, :marked?, true)
  end
end

defmodule Aoc.Bingo do
  @moduledoc """
  A struct for the bingo game in 2021 Day 4.
  """
  alias Aoc.Bingo.Card

  def call(%{numbers: []}, _) do
    :no_winning_cards
  end

  def call(%{cards: cards, numbers: [number | numbers]}, strategy) do
    cards = Enum.map(cards, &Card.mark(&1, number))

    case check_cards(cards, strategy) do
      {%Card{} = card, _} ->
        Card.score(card) * number

      {nil, cards} ->
        call(%{cards: cards, numbers: numbers}, strategy)
    end
  end

  def check_cards(cards, :win) do
    {Enum.find(cards, &Card.winning?/1), cards}
  end

  def check_cards([_] = cards, :lose) do
    {Enum.find(cards, &Card.winning?/1), cards}
  end

  def check_cards([_ | _] = cards, :lose) do
    {nil, Enum.reject(cards, &Card.winning?/1)}
  end
end
