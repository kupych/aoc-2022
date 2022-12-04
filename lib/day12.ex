defmodule Aoc.Day12 do
  @moduledoc """
  Solutions for Day 12.
  """
  @behaviour Aoc.Day

  alias Aoc.Day

  @impl Day
  def day(), do: 12

  @impl Day
  def a(_) do
    :ok
  end

  @impl Day
  def b(_) do
    :ok
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
    end
  end
end
