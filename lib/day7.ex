defmodule Aoc.Day7 do
  @moduledoc """
  Solutions for Day 7.
  """
  @behaviour Aoc.Day

  alias Aoc.Day

  @total_space 70_000_000
  @free_space_needed 30_000_000

  @impl Day
  def day(), do: 7

  @impl Day
  def a(%{dirs: dirs}) do
    dirs
    |> Enum.filter(fn {_, v} -> v <= 100_000 end)
    |> Map.new()
    |> Map.values()
    |> Enum.sum()
  end

  @impl Day
  def b(%{dirs: dirs}) do
    free_space = @total_space - Map.get(dirs, [])
    free_space_needed = @free_space_needed - free_space

    dirs
    |> Map.values()
    |> Enum.reject(&(&1 < free_space_needed))
    |> Enum.sort()
    |> hd()
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n", trim: true)
      |> tl()
      |> Enum.reduce(%{path: [], dirs: %{}}, &parse_history/2)
    end
  end

  def parse_history("$ cd ..", %{path: []} = data) do
    data
  end

  def parse_history("$ cd ..", %{path: [_ | path]} = data) do
    %{data | path: path}
  end

  def parse_history("$ cd " <> dir, %{path: path} = data) do
    %{data | path: [dir | path]}
  end

  def parse_history("dir " <> dir, %{dirs: dirs, path: path} = data) do
    %{data | dirs: Map.put_new(dirs, [dir | path], 0)}
  end

  def parse_history("$" <> _, data) do
    data
  end

  def parse_history(file_info, data) do
    {size, _} = Integer.parse(file_info)
    add_size_to_paths(data, size)
  end

  def add_size_to_paths(%{path: path} = data, size) when is_integer(size) do
    do_add_size_to_paths(data, path, size)
  end

  def do_add_size_to_paths(%{dirs: dirs} = data, [_ | rest] = path, size) do
    dirs = Map.update(dirs, path, size, &(&1 + size))

    data
    |> Map.put(:dirs, dirs)
    |> do_add_size_to_paths(rest, size)
  end

  def do_add_size_to_paths(%{dirs: dirs} = data, [], size) do
    dirs = Map.update(dirs, [], size, &(&1 + size))
    %{data | dirs: dirs}
  end
end
