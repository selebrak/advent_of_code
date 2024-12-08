defmodule Aoc2024.Day03 do
  @moduledoc """
  Advent of Code Day 3 2024
  """

  @input_filepath Path.expand("../../priv/inputs/2024/day-03-input.txt", __DIR__)
  @instr_pattern ~r/mul\([0-9]{1,3},[0-9]{1,3}\)/

  def print_solutions() do
    IO.inspect(part1())
    IO.inspect(part2())
  end

  def part1() do
    read_memory_dump(@input_filepath)
    |> match_instructions()
    |> Enum.map(fn instr -> String.slice(instr, 4..-2//1) end)
    |> Enum.map(fn partial -> String.split(partial, ",") end)
    |> Enum.reduce(0, fn [s1, s2], acc -> String.to_integer(s1) * String.to_integer(s2) + acc end)
  end

  def part2() do
    nil
  end

  def read_memory_dump(filepath) do
    filepath
    |> File.read!()
    |> String.replace("\n", "") # treat as one contiguous memory block
  end

  def match_instructions(memory_dump) do
    Regex.scan(@instr_pattern, memory_dump, capture: :all)
    |> List.flatten()
  end
end
