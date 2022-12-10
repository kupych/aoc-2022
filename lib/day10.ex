defmodule Aoc.Day10 do
  @moduledoc """
  Solutions for Day 10.
  """
  @behaviour Aoc.Day

  alias Aoc.Day

  @screen_width 40
  @on_char "#"
  @off_char "."

  @impl Day
  def day(), do: 10

  @impl Day
  def a(instructions) do
    instructions
    |> Enum.with_index(1)
    |> Enum.drop(19)
    |> Enum.take_every(40)
    |> Enum.map(&Tuple.product/1)
    |> Enum.sum()
  end

  @impl Day
  def b(instructions) do
    grid =
      instructions
      |> Enum.with_index()
      |> draw()

    "\n" <> grid
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n", trim: true)
      |> Enum.reduce([1], &parse_instruction/2)
      |> Enum.reverse()
    end
  end

  def parse_instruction(instruction, values \\ [1])

  def parse_instruction("noop", [value | _] = values) do
    [value | values]
  end

  def parse_instruction("addx " <> amount, [current | _] = values) do
    amount = String.to_integer(amount)
    [amount + current | [current | values]]
  end

  def draw(instructions) do
    instructions
    |> Enum.map(&check_pixel/1)
    |> Enum.chunk_every(@screen_width)
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.join("\n")
  end

  def check_pixel({location, index}) do
    index
    |> rem(@screen_width)
    |> Kernel.-(location)
    |> Kernel.abs()
    |> case do
      diff when diff <= 1 -> @on_char
      _ -> @off_char
    end
  end
end
