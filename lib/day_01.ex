defmodule Aoc2024.Day01 do
  @moduledoc """
  Day 1: Historian Hysteria

  This module solves two problems.
  In the first problem, where we need to compare two lists of numbers and calculate the total distance between them

  To solve this, the numbers in the lists are paired in a specific way:
  - Both lists are sorted.
  - The smallest number in the first list is paired with the smallest number in the second list, the second smallest with the second smallest, and so on.

  After pairing, we calculate the distance between each pair by taking the absolute difference of the two numbers.
  The total distance is the sum of all these differences.

  ## Example
  Given the input:
      3   4
      4   3
      2   5
      1   3
      3   9
      3   3

  After sorting and pairing:
      Left list:  [1, 2, 3, 3, 3, 4]
      Right list: [3, 3, 3, 4, 5, 9]

  The distances between each pair are:
      |1 - 3| = 2
      |2 - 3| = 1
      |3 - 3| = 0
      |3 - 4| = 1
      |3 - 5| = 2
      |4 - 9| = 5

  Total distance = 2 + 1 + 0 + 1 + 2 + 5 = 11

  In the second problem, we need to compare two lists of numbers and calculate the similarity between them.
  The similarity is the sum of the absolute differences between each pair.

  ## Example
  Given the input:
      3   4
      4   3
      2   5
      1   3
      3   9
      3   3

  The left list is `[3, 4, 2, 1, 3, 3]` and the right list is `[4, 3, 5, 3, 9, 3]`.

  The similarity score is calculated as:
      3 appears in the right list 3 times: 3 * 3 = 9
      4 appears in the right list 1 time:  4 * 1 = 4
      2 appears in the right list 0 times: 2 * 0 = 0
      1 appears in the right list 0 times: 1 * 0 = 0
      3 appears in the right list 3 times: 3 * 3 = 9
      3 appears in the right list 3 times: 3 * 3 = 9

  Total similarity score = 9 + 4 + 0 + 0 + 9 + 9 = 31.
  """

  @doc """
  Solves the problem by reading the input from a file and printing the total distance and the similarity score.

  ## Examples
      iex> File.write!("temp_input.txt", "3 4\\n4 3\\n2 5\\n1 3\\n3 9\\n3 3")
      iex> capture_io(fn -> Aoc2024.Day01.solve("temp_input.txt") end)
      "Total distance: 11\\nSimilarity score: 31\\n"
      iex> File.rm("temp_input.txt")
  """
  @spec solve(String.t()) :: :ok
  def solve(input_file) do
    input_content = File.read!(input_file)
    IO.puts("Total distance: #{total_distance(input_content)}")
    IO.puts("Similarity score: #{similarity(input_content)}")
  end

  @doc """
  Parses a columnar input string into two lists of integers.

  ## Examples

      iex> input = "3 4\\n4 3\\n2 5\\n1 3\\n3 9\\n3 3"
      iex> Aoc2024.Day01.parse_columns(input)
      {[3, 4, 2, 1, 3, 3], [4, 3, 5, 3, 9, 3]}
  """
  @spec parse_columns(String.t()) :: {list(integer()), list(integer())}
  def parse_columns(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [left, right] = String.split(line, ~r/\s+/, trim: true)
      {String.to_integer(left), String.to_integer(right)}
    end)
    |> Enum.unzip()
  end

  @doc """
  Calculates the total distance between two lists of numbers from the input string.

  ## Examples

      iex> input = "3 4\\n4 3\\n2 5\\n1 3\\n3 9\\n3 3"
      iex> Aoc2024.Day01.total_distance(input)
      11
  """
  @spec total_distance(String.t()) :: integer()
  def total_distance(input) do
    {left, right} = parse_columns(input)

    left_sorted = Enum.sort(left)
    right_sorted = Enum.sort(right)

    Enum.zip(left_sorted, right_sorted)
    |> Enum.map(fn {l, r} -> abs(l - r) end)
    |> Enum.sum()
  end

  @doc """
  Calculates the similarity between two lists of numbers from the input string.

  ## Examples
  iex> input = "3 4\\n4 3\\n2 5\\n1 3\\n3 9\\n3 3"
  iex> Aoc2024.Day01.similarity(input)
  31
  """
  @spec similarity(String.t()) :: integer()
  def similarity(input) do
    {left, right} = parse_columns(input)

    frequency_map = Enum.frequencies(right)

    Enum.reduce(left, 0, fn num, acc ->
      acc + num * Map.get(frequency_map, num, 0)
    end)
  end
end
