defmodule Aoc.Day8 do
  @moduledoc """
  Solutions for Day 8.
  """
  @behaviour Aoc.Day

  @segments %{
    0 => "abcefg",
    1 => "cf",
    2 => "acdeg",
    3 => "acdfg",
    4 => "bcdf",
    5 => "abdfg",
    6 => "abdefg",
    7 => "acf",
    8 => "abcdefg",
    9 => "abcdfg"
  }
  
  @reverse_segments %{
    "abcefg" => "0",
    "cf" => "1",
    "acdeg" => "2",
    "acdfg" => "3",
    "bcdf" => "4",
    "abdfg" => "5",
    "abdefg" => "6",
    "acf" => "7",
    "abcdefg" => "8",
    "abcdfg" => "9"
  }

  alias Aoc.Day

  @impl Day
  def day(), do: 8

  @impl Day
  def a(lines) do
    lengths =
      [1, 4, 7, 8]
      |> Enum.map(&Map.get(@segments, &1))
      |> Enum.map(&String.length/1)

    lines
    |> Enum.map(&find_segment_counts/1)
    |> Enum.map(&Map.take(&1, lengths))
    |> Enum.flat_map(&Map.values/1)
    |> Enum.sum()
  end

  @impl Day
  def b(lines) do
    lines
    |> Enum.map(&decipher_line/1)
    |> Enum.sum()
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&process_line/1)
    end
  end

  def find_segment_counts([_, digits]) do
    digits
    |> Enum.map(&String.length/1)
    |> Enum.frequencies()
  end

  def process_line(line) do
    line
    |> String.split("|", trim: true)
    |> Enum.map(&String.split(&1, " ", trim: true))
  end

  def decipher_line([patterns, output]) do
    sorted =
      patterns
      |> Enum.sort_by(&String.length/1)
      |> Enum.map(&String.codepoints/1)
      |> Enum.map(&Enum.sort/1)

    [one | [seven | _]] = sorted

    [a] = seven -- one

    frequencies =
      sorted
      |> List.flatten()
      |> Enum.frequencies()

    [f] = find_matching_segment_counts(frequencies, 9)
    [c] = one -- [f]

    four = Enum.find(sorted, &(Enum.count(&1) == 4))

    [g, d] = 
      frequencies
      |> find_matching_segment_counts(7)
      |> Enum.sort_by(&Enum.member?(four, &1))

    [b] = find_matching_segment_counts(frequencies, 6)
    [e] = find_matching_segment_counts(frequencies, 4)

    cipher = %{
      a => "a",
      b => "b",
      c => "c",
      d => "d",
      e => "e",
      f => "f",
      g => "g"
    }

    output
    |> Enum.map(&get_number(&1, cipher))
    |> Enum.join()
    |> String.to_integer()
  end

  def get_number(digit, cipher) do
    deciphered = digit
    |> String.codepoints()
    |> Enum.sort()
    |> Enum.map(&Map.get(cipher, &1))
    |> Enum.sort()
    |> Enum.join()

    Map.get(@reverse_segments, deciphered)
  end

  def find_matching_segment_counts(frequencies, value) do
    frequencies
    |> Enum.filter(fn
      {_, ^value} -> true
      _ -> false
    end)
    |> Enum.map(&elem(&1, 0))
  end
end
