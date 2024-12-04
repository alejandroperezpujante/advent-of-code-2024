defmodule Aoc2024.Day01Test do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias Aoc2024.Day01

  doctest Aoc2024.Day01

  @test_input """
  3 4
  4 3
  2 5
  1 3
  3 9
  3 3
  """

  describe "parse_columns/1" do
    test "parses the input into two lists of integers" do
      assert Day01.parse_columns(@test_input) == {[3, 4, 2, 1, 3, 3], [4, 3, 5, 3, 9, 3]}
    end

    test "handles empty input" do
      assert Day01.parse_columns("") == {[], []}
    end
  end

  describe "total_distance/1" do
    test "calculates the correct total distance for the given input" do
      assert Day01.total_distance(@test_input) == 11
    end

    test "returns 0 for empty input" do
      assert Day01.total_distance("") == 0
    end

    test "calculates distance for one pair of numbers" do
      input = "10 20"
      assert Day01.total_distance(input) == 10
    end
  end

  describe "solve/1" do
    setup do
      # Create a temporary file to test the solve function
      test_file = "temp_input.txt"
      File.write!(test_file, @test_input)
      on_exit(fn -> File.rm(test_file) end)
      %{test_file: test_file}
    end

    test "outputs the correct result for the input file", %{test_file: test_file} do
      assert capture_io(fn -> Day01.solve(test_file) end) == "Total distance: 11\n"
    end

    test "handles empty files gracefully", %{test_file: test_file} do
      File.write!(test_file, "")
      assert capture_io(fn -> Day01.solve(test_file) end) == "Total distance: 0\n"
    end
  end
end
