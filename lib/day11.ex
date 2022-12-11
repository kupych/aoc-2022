defmodule Aoc.Day11 do
  @moduledoc """
  Solutions for Day 11.
  """
  @behaviour Aoc.Day

  alias Aoc.Day

  @impl Day
  def day(), do: 11

  @impl Day
  def a(monkeys) do
    monkeys
    |> run_rounds(20)
    |> Map.values()
    |> Enum.map(& &1.inspect_count)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.product()
  end

  @impl Day
  def b(monkeys) do
    monkeys
    |> run_rounds(10000, common_quotient(monkeys))
    |> Map.values()
    |> Enum.map(& &1.inspect_count)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.product()
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n\n", trim: true)
      |> Enum.map(&String.split(&1, "\n"))
      |> Enum.map(&parse_monkey/1)
      |> Enum.with_index()
      |> Enum.map(fn {x, i} -> {i, x} end)
      |> Map.new()
    end
  end

  def bored(worry_level), do: worry_level |> Kernel.div(3)

  def parse_monkey(definition, monkey \\ %{inspect_count: 0})

  def parse_monkey([], monkey) do
    monkey
  end

  def parse_monkey(["  Starting items: " <> items | definition], monkey) do
    items =
      items
      |> String.split(", ", trim: true)
      |> Enum.map(&String.to_integer/1)

    parse_monkey(definition, Map.put(monkey, :items, items))
  end

  def parse_monkey(["  Operation:" <> operation | definition], monkey) do
    [_, _, _, operation, operand] = String.split(operation)
    operation = String.to_existing_atom(operation)

    operand =
      case Integer.parse(operand) do
        :error -> :self
        {operand, _} -> operand
      end

    parse_monkey(definition, Map.merge(monkey, %{operand: operand, operation: operation}))
  end

  def parse_monkey(["  Test: divisible by " <> quotient | definition], monkey) do
    parse_monkey(definition, Map.put(monkey, :quotient, String.to_integer(quotient)))
  end

  def parse_monkey(["    If " <> condition | definition], monkey) do
    [condition, _, _, _, dest] = String.split(condition, ~r/\W+/, trim: true)
    condition = String.to_existing_atom(condition)
    dest = String.to_integer(dest)
    parse_monkey(definition, Map.put(monkey, condition, dest))
  end

  def parse_monkey([_ | instructions], monkey) do
    parse_monkey(instructions, monkey)
  end

  def run_rounds(monkeys, rounds \\ 1, common_quotient \\ false) do
    1..rounds
    |> Enum.reduce(monkeys, &run_round(&1, &2, common_quotient))
  end

  def run_round(_, monkeys, common_quotient) do
    Enum.reduce(monkeys, monkeys, &run_monkey(&1, &2, common_quotient))
  end

  def run_monkey({index, _}, monkeys, common_quotient) do
    case Map.get(monkeys, index) do
      %{inspect_count: count, items: [item | items]} = monkey ->
        item =
          item
          |> inspect_item(monkey)

        item = if common_quotient, do: rem(item, common_quotient(monkeys)), else: bored(item)

        other_index = monkey[rem(item, monkey.quotient) == 0]
        %{items: other_items} = other_monkey = Map.get(monkeys, other_index)

        monkey = %{monkey | inspect_count: count + 1, items: items}
        other_monkey = %{other_monkey | items: other_items ++ [item]}

        monkeys =
          monkeys
          |> Map.put(index, monkey)
          |> Map.put(other_index, other_monkey)

        run_monkey({index, %{}}, monkeys, common_quotient)

      %{items: []} ->
        monkeys
    end
  end

  def inspect_item(item, %{operand: :self, operation: operation}) do
    apply(Kernel, operation, [item, item])
  end

  def inspect_item(item, %{operand: operand, operation: operation}) when is_integer(operand) do
    apply(Kernel, operation, [item, operand])
  end

  def common_quotient(monkeys) do
    monkeys
    |> Map.values()
    |> Enum.map(& &1.quotient)
    |> Enum.product()
  end
end
