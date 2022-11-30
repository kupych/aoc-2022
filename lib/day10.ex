defmodule Aoc.Day10 do
  @moduledoc """
  Solutions for Day 10.
  """
  @behaviour Aoc.Day

  alias Aoc.Day

  @opening_brackets ["(", "[", "{", "<"]

  @completion_score %{
    "(" => 1,
    "[" => 2,
    "{" => 3,
    "<" => 4
  }

  @impl Day
  def day(), do: 10

  @impl Day
  def a(lines) do
    lines
    |> Enum.map(&validate_line/1)
    |> Enum.map(& &1.score)
    |> Enum.sum()
  end

  @impl Day
  def b(lines) do
    completion_scores =
      lines
      |> Enum.map(&validate_line/1)
      |> Enum.filter(&incomplete_line?/1)
      |> Enum.map(&(completion_score(&1.stack)))
      |> Enum.sort()

    Enum.at(completion_scores, div(length(completion_scores), 2))
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&String.codepoints/1)
    end
  end

  def validate_line(chars, stack \\ [])

  def validate_line([], stack) do
    %{score: 0, stack: stack}
  end

  def validate_line([char | rest], stack) when char in @opening_brackets do
    validate_line(rest, [char | stack])
  end

  def validate_line([char | rest], [match | stack]) do
    case match(match, char) do
      :ok -> validate_line(rest, stack)
      error -> %{score: error}
    end
  end

  def completion_score(stack, score \\ 0)

  def completion_score([], score) do
    score
  end

  def completion_score([char | stack], score) do
    completion_score(stack, score * 5 + @completion_score[char])
  end

  def incomplete_line?(%{score: 0, stack: [_ | _]}), do: true
  def incomplete_line?(_), do: false

  def match("[", "]"), do: :ok
  def match("(", ")"), do: :ok
  def match("{", "}"), do: :ok
  def match("<", ">"), do: :ok
  def match(_, ")"), do: 3
  def match(_, "]"), do: 57
  def match(_, "}"), do: 1197
  def match(_, ">"), do: 25137
end
