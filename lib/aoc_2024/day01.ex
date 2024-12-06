defmodule Aoc2024.Day01 do
  @moduledoc """
  Advent of Code Day 1 2024
  """

  @input_filepath Path.expand("../../priv/inputs/2024/day-01-input.txt", __DIR__)

  def print_solutions() do
    IO.puts(part1())
    IO.puts(part2())
  end

  def part1() do
    {list1, list2} = lists_from_file(@input_filepath)
    inter_list_distance(list1, list2)
  end

  def part2() do
    {list1, list2} = lists_from_file(@input_filepath)
    similarity_score(list1, list2)
  end

  def inter_list_distance(list1, list2) do
    sorted_list1 = Enum.sort(list1)
    sorted_list2 = Enum.sort(list2)

    sorted_list1
    |> Enum.zip(sorted_list2)
    |> Enum.map(fn {x,y} -> abs(x - y) end)
    |> Enum.reduce(0, &+/2) # or Enum.sum()
  end

  def similarity_score(list1, list2) do
    list2_freqmap = Enum.frequencies(list2)

    list1
    |> Enum.map(&multiply_by_frequency(&1, list2_freqmap))
    |> Enum.sum()
  end

  def multiply_by_frequency(input, freqmap) do
    freqmap
    |> Map.get(input, 0)
    |> Kernel.*(input)
  end

  def lists_from_file(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(fn [x, y] -> {x, y} end)
    |> Enum.unzip()
  end
end
