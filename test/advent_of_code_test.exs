defmodule AdventOfCodeTest do
  use ExUnit.Case
  doctest AdventOfCode

  test "day1 problem 1" do
    assert read_two_column_file("../support/inputs/2024-day01-p1.txt") |> AdventOfCode.inter_list_distance == TODO
  end

  def read_two_column_file(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.unzip()
  end

  def process_file(filename) do
    {list1, list2} = read_two_column_file(filename)
    calculate_total_differences(list1, list2)
  end
end
