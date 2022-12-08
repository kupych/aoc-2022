defmodule Aoc.Day8 do
  @moduledoc """
  Solutions for Day 8.
  """
  @behaviour Aoc.Day

  alias Aoc.Day

  @impl Day
  def day(), do: 8

  @impl Day
  def a(tree_map) do
    tree_map
    |> set_visible()
    |> Map.values()
    |> Enum.count(& &1.visible?)
  end

  @impl Day
  def b(tree_map) do
    tree_map
    |> set_visible()
    |> Map.values()
    |> Enum.map(&Enum.product(&1.distances))
    |> Enum.max()
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.codepoints()
      |> Enum.reverse()
      |> tl()
      |> Enum.reverse()
      |> Enum.reduce(%{pos: {0, 0}}, &map_trees/2)
      |> Map.delete(:pos)
    end
  end

  def map_trees("\n", %{pos: {_, y}} = tree_map) do
    %{tree_map | pos: {0, y + 1}}
  end

  def map_trees(height, %{pos: {x, y} = pos} = tree_map) do
    tree_map
    |> Map.put(pos, %{height: String.to_integer(height), visible?: false, distances: []})
    |> Map.put(:pos, {x + 1, y})
  end

  def set_visible(tree_map) do
    tree_map
    |> Enum.map(&get_distances(&1, tree_map))
    |> Map.new()
  end

  def get_distances(data, tree_map) do
    data =
      [{0, -1}, {1, 0}, {0, 1}, {-1, 0}]
      |> Enum.reduce(data, &get_distance(&1, &2, tree_map))
  end

  def get_distance(
        velocity,
        {pos, %{height: height, visible?: visible?, distances: distances} = value},
        tree_map
      ) do
    {visible, distance} = do_check_distance(pos, velocity, height, tree_map, 0)
    {pos, %{height: height, visible?: visible? or visible, distances: [distance | distances]}}
  end

  def do_check_distance({x, y}, {dx, dy}, height, tree_map, distance) do
    case Map.get(tree_map, {x + dx, y + dy}) do
      %{height: other_height} when other_height < height ->
        do_check_distance({x + dx, y + dy}, {dx, dy}, height, tree_map, distance + 1)

      nil ->
        {true, distance}

      _ ->
        {false, distance + 1}
    end
  end
end
