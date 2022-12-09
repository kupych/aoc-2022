defmodule Aoc.Day9 do
  @moduledoc """
  Solutions for Day 9.
  """
  @behaviour Aoc.Day

  alias Aoc.Day

  @directions %{
    "D" => {0, -1},
    "L" => {-1, 0},
    "R" => {1, 0},
    "U" => {0, 1}
  }

  @impl Day
  def day(), do: 9

  @impl Day
  def a(directions) do
    track_tail_visited(directions, 2)
  end

  @impl Day
  def b(directions) do
    directions
    |> Enum.reduce(%{visited: [], rope: new_rope(10)}, &move_rope/2)
    |> Map.get(:visited)
    |> Enum.uniq()
    |> Enum.count()
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_direction/1)
    end
  end

  def parse_direction(<<direction::binary-size(1)>> <> " " <> distance) do
    distance
    |> String.to_integer()
    |> then(&Enum.map(1..&1, fn _ -> @directions[direction] end))
  end

  def track_tail_visited(directions, rope_size)
      when is_list(directions) and is_integer(rope_size) and rope_size > 1 do
    directions
    |> Enum.reduce(%{visited: [], rope: new_rope(rope_size)}, &move_rope/2)
    |> Map.get(:visited)
    |> Enum.uniq()
    |> Enum.count()
  end

  def move_rope([], data) do
    data
  end

  def move_rope([{dx, dy} | movements], %{visited: visited, rope: [{x, y} | rope]}) do
    head = {x + dx, y + dy}
    {rope, tail} = maybe_follow(head, rope)

    move_rope(movements, %{visited: [tail | visited], rope: rope})
  end

  def maybe_follow(head, tail, front \\ [])

  def maybe_follow(tail, [], front) do
    {Enum.reverse([tail | front]), tail}
  end

  def maybe_follow({head_x, head_y} = head, [{next_x, next_y} | tail], front) do
    next =
      case {head_x - next_x, head_y - next_y} do
        {dx, dy} when abs(dx) < 2 and abs(dy) < 2 ->
          {next_x, next_y}

        {dx, dy} when abs(dx) > abs(dy) ->
          {next_x + div(dx, 2), next_y + dy}

        {dx, dy} when abs(dx) < abs(dy) ->
          {next_x + dx, next_y + div(dy, 2)}

        {dx, dy} ->
          {next_x + div(dx, 2), next_y + div(dy, 2)}
      end

    maybe_follow(next, tail, [head | front])
  end

  def new_rope(size) when is_integer(size) and size > 1 do
    Enum.map(1..size, fn _ -> {0, 0} end)
  end
end
