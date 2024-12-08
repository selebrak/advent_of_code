defmodule Aoc2024.Day03 do
  @moduledoc """
  Advent of Code Day 3 2024
  """

  # TODO: Better comments

  @input_filepath Path.expand("../../priv/inputs/2024/day-03-input.txt", __DIR__)
  @mul_pattern ~r/mul\([0-9]{1,3},[0-9]{1,3}\)/
  @cond_mul_pattern ~r/mul\([0-9]{1,3},[0-9]{1,3}\)|do\(\)|don\'t\(\)/

  def print_solutions() do
    IO.inspect(part1())
    IO.inspect(part2())
  end

  def part1() do
    read_memory_dump(@input_filepath)
    |> match_instructions(@mul_pattern)
    |> process_mul()
  end

  def part2() do
    read_memory_dump(@input_filepath)
    |> match_instructions(@cond_mul_pattern)
    |> keep_enabled()
    |> process_mul()
  end

  def read_memory_dump(filepath) do
    filepath
    |> File.read!()
    |> String.replace("\n", "") # treat as one contiguous memory block
  end

  def match_instructions(memory_dump, pattern) do
    Regex.scan(pattern, memory_dump, capture: :all)
    |> List.flatten()
  end

  def process_mul(instr_list) do
    instr_list
    |> Enum.map(fn instr -> String.slice(instr, 4..-2//1) end)
    |> Enum.map(fn partial -> String.split(partial, ",") end)
    |> Enum.reduce(0, fn [s1, s2], acc -> String.to_integer(s1) * String.to_integer(s2) + acc end)
  end

  # recursively remove disabled instructions from a given list
  # returns the non-disabled list
  # also removes the do's, a a side effect
  def keep_enabled([]), do: []

  def keep_enabled(instr_list) do
    ## accumulate the list to return and ++ to recursive call on remaining
    # 1. acc the start to first don't (can always assume good)
    # 2. call on list AFTER first do

    do_pos = Enum.find_index(instr_list, fn e -> e == "do\(\)" end)
    dont_pos = Enum.find_index(instr_list, fn e -> e == "don\'t\(\)" end)

    case {do_pos, dont_pos} do
      {nil, nil} ->
        # no more do's nor don'ts - return the remaining list
        instr_list
      {_, nil} ->
        # no more don'ts, acc until first do then call after do
        {left, right} = Enum.split(instr_list, do_pos)
        left ++ keep_enabled(tl(right))
      {nil, _} ->
        # no more do's BUT at least one don't. return list BEFORE it.
        # aka take dont_pos many elements from the list
        Enum.take(instr_list, dont_pos)
      {do_pos, dont_pos} ->
        # at least one do and dont:
        # - if do < dont, acc until do and call on sublist after
        # - if do > dont, acc until dont (may be nothing) and call on sublist after do
        if do_pos < dont_pos do
          {left, right} = Enum.split(instr_list, do_pos)
          left ++ keep_enabled(tl(right))
        else
          # take until dont - may be nothing
          # then call on sublist after do
          {left, _right} = Enum.split(instr_list, dont_pos)
          left ++ keep_enabled(
            Enum.slice(instr_list, (do_pos + 1)..-1//1)
          )
        end
    end
  end
end
