defmodule Aoc.Day3 do
  @moduledoc """
  Solutions for Day 3.
  """
  @behaviour Aoc.Day

  alias Aoc.{Day, Utilities}

  @impl Day
  def day(), do: 3

  @impl Day
  def a(bits) do
    {gamma, epsilon} = get_gamma_and_epsilon(bits)

    String.to_integer(gamma, 2) * String.to_integer(epsilon, 2)
  end

  @impl Day
  def b(bits) do
    oxygen_generator_rating =
      bits
      |> filter_values(&Enum.max_by/2)
      |> binary_list_to_number()

    co2_scrubber_rating =
      bits
      |> filter_values(&Enum.min_by/2)
      |> binary_list_to_number()

    oxygen_generator_rating * co2_scrubber_rating
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&String.codepoints/1)
    end
  end

  defp get_max(%{} = values) do
    values
    |> Enum.max_by(&elem(&1, 1))
    |> elem(0)
  end

  defp binary_list_to_number([_ | _] = list) do
    list
    |> Enum.join()
    |> String.to_integer(2)
  end

  defp reverse_binary(string, new_string \\ "")

  defp reverse_binary("", new_string) do
    new_string
  end

  defp reverse_binary("1" <> string, new_string) do
    reverse_binary(string, new_string <> "0")
  end

  defp reverse_binary("0" <> string, new_string) do
    reverse_binary(string, new_string <> "1")
  end

  defp get_gamma_and_epsilon(bits) do
    gamma =
      bits
      |> Utilities.transpose()
      |> Enum.map(&Enum.frequencies/1)
      |> Enum.map(&get_max/1)
      |> Enum.join()

    {gamma, reverse_binary(gamma)}
  end

  defp filter_values(values, type, index \\ 0)

  defp filter_values([value], _, _) do
    value
  end

  defp filter_values([], _, _) do
    :error
  end

  defp filter_values(values, function, index) do
    frequencies =
      values
      |> Enum.map(&Enum.at(&1, index))
      |> Enum.frequencies()

    {value, _} = function.(frequencies, fn {k, v} -> {v, k} end)

    values
    |> Enum.filter(&(Enum.at(&1, index) == value))
    |> filter_values(function, index + 1)
  end
end
