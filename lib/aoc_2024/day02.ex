defmodule Aoc2024.Day02 do
  @moduledoc """
  Advent of Code Day 2 2024
  """

  @input_filepath Path.expand("../../priv/inputs/2024/day-02-input.txt", __DIR__)

  def print_solutions() do
    IO.puts(part1())
    IO.puts(part2())
  end

  def part1() do
    reports_from_file(@input_filepath)
  end

  def part2() do
    reports_from_file(@input_filepath)
  end

  def reports_from_file(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> #TODO
  end
end
