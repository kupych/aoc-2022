defmodule Aoc.Day14 do
  @moduledoc """
  Solutions for Day 14.
  """
  @behaviour Aoc.Day

  alias Aoc.Day

  @impl Day
  def day(), do: 14

  @impl Day
  def a({initial, rules}) do
    1..10
    |> Enum.reduce(initial, &grow(&1, &2, rules))
    |> score()
  end

  @impl Day
  def b({initial, rules}) do
    1..40
    |> Enum.reduce(initial, &grow(&1, &2, rules))
    |> score()
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      do_parse_input(file)
    end
  end

  def do_parse_input(file) do
    [polymer, rules] = String.split(file, "\n\n", trim: true)
    initial_count = parse_polymer(polymer)

    rules =
      rules
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_rule/1)
      |> Map.new()

    {initial_count, rules}
  end

  def parse_polymer(polymer, count \\ %{})

  def parse_polymer(<<_>>, %{} = count) do
    count
  end

  def parse_polymer(<<a::binary-size(1), b::binary-size(1)>> <> rest, %{} = count) do
    count =
      if map_size(count) == 0 do
        %{"_#{a}" => 1}
      else
        count
      end

    parse_polymer(b <> rest, Map.update(count, a <> b, 1, &(&1 + 1)))
  end

  def score(count) do
    {{_, min}, {_, max}} =
      count
      |> Enum.reduce(%{}, &score_rule/2)
      |> Enum.min_max_by(&elem(&1, 1))

    max - min
  end

  def score_rule({<<_, last::binary>>, score}, scores) do
    Map.update(scores, last, score, &(&1 + score))
  end

  def parse_rule(<<a::binary-size(1), b::binary-size(1)>> <> " -> " <> add) do
    {a <> b, [a <> add, add <> b]}
  end

  def grow(_, polymer_count, rules) do
    polymer_count
    |> Enum.reduce(%{}, &do_grow(&1, &2, rules))
  end

  def do_grow({chain, count}, new_polymer, rules) do
    case Map.get(rules, chain) do
      nil ->
        Map.update(new_polymer, chain, count, &(&1 + count))

      [new_a, new_b] ->
        new_polymer
        |> Map.update(new_a, count, &(&1 + count))
        |> Map.update(new_b, count, &(&1 + count))
    end
  end
end
