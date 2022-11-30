defmodule Aoc.Utilities do
  @moduledoc """
  Generic utilities for Advent of Code puzzles.
  """

  @doc """
  `transpose/1` transposes a 2d-array, i.e. 
  converts rows to columns and vice versa.
  """
  def transpose(matrix) do
    matrix
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  @doc """
  `binary_to_digits/1` takes a string of 
  numbers and converts it to a tuple of
  integers representing the digits.
  """
  def binary_to_digits(string) do
    string
    |> binary_to_digit_enum()
    |> List.to_tuple()
  end

  def binary_to_digit_enum(string) do
    string
    |> String.codepoints()
    |> Enum.map(&String.to_integer/1)
  end
end
