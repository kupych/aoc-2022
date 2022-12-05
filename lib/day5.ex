defmodule Aoc.Day5 do
  @moduledoc """
  Solutions for Day 5.
  """
  @behaviour Aoc.Day

  alias Aoc.Day

  @impl Day
  def day(), do: 5

  @impl Day
  def a(data) do
    solve(data, :a)
  end

  @impl Day
  def b(data) do
    solve(data, :b)
  end

  def solve(%{boxes: boxes, steps: steps}, part) do
    steps
    |> Enum.reduce(boxes, &run_step(&1, &2, part))
    |> Enum.map(&elem(&1, 1))
    |> Enum.map(&hd/1)
    |> Enum.join("")
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n", trim: true)
      |> parse_line()
    end
  end

  def parse_line(lines, acc \\ %{boxes: %{}, steps: []})

  def parse_line([], %{steps: steps} = acc) do
    %{acc | steps: Enum.reverse(steps)}
  end

  def parse_line([line | lines], acc) do
    cond do
      Regex.match?(~r/^(\s*\[\w\])+$/, line) -> parse_line(lines, parse_boxes(line, acc))
      Regex.match?(~r/move/, line) -> parse_line(lines, parse_instruction(line, acc))
      true -> parse_line(lines, acc)
    end
  end

  def parse_instruction(line, %{steps: steps} = acc) do
    action =
      ~r/move (\d+) from (\d+) to (\d+)/
      |> Regex.run(line)
      |> tl()
      |> Enum.map(&String.to_integer/1)

    %{acc | steps: [action | steps]}
  end

  def parse_boxes(boxes, acc) do
    boxes
    |> String.split("", trim: true)
    |> tl()
    |> Enum.take_every(4)
    |> add_to_stack(acc)
  end

  def add_to_stack(layer, %{boxes: boxes} = acc) do
    boxes =
      layer
      |> Enum.with_index(1)
      |> Enum.reduce(boxes, &do_add_to_stack/2)

    %{acc | boxes: boxes}
  end

  def do_add_to_stack({" ", _}, boxes) do
    boxes
  end

  def do_add_to_stack({box, index}, boxes) do
    Map.update(boxes, index, [box], &Enum.concat(&1, [box]))
  end

  def run_step([move_count, from_index, to_index], boxes, part) do
    from_col = Map.get(boxes, from_index)
    to_col = Map.get(boxes, to_index)

    {boxes_to_move, from_col} = Enum.split(from_col, move_count)

    to_col =
      case part do
        :a -> Enum.reduce(boxes_to_move, to_col, &[&1 | &2])
        :b -> Enum.concat(boxes_to_move, to_col)
      end

    boxes
    |> Map.put(from_index, from_col)
    |> Map.put(to_index, to_col)
  end
end
