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
    count_safe_reports(@input_filepath)
  end

  def part2() do
    @input_filepath
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split/1)
    |> Stream.map(fn report -> Enum.map(report, &String.to_integer/1) end)
    |> Task.async_stream(&dampened_test_safe/1)
    |> Stream.map(fn {:ok, result} -> result end)
    |> Enum.sum()
  end

  def count_safe_reports(filepath) do
    # TODO move file reading and data massaging into separate function?
    filepath
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split/1)
    |> Stream.map(fn report -> Enum.map(report, &String.to_integer/1) end)
    |> Task.async_stream(&test_safe/1)
    |> Stream.map(fn {:ok, result} -> result end)
    |> Enum.sum()
  end

  # TODO: refactor logic and optimize for tail recursion?
  def test_safe([e1, e2 | tail]) do
    level_difference = e1 - e2
    cond do
      -1 >= level_difference and level_difference >= -3 ->
        test_safe_incr([e2 | tail])
      1 <= level_difference and level_difference <= 3 ->
        test_safe_decr([e2 | tail])
      true ->
        0
    end
  end

  def test_safe_incr([_e1]), do: 1

  def test_safe_incr([e1, e2 | tail]) do
    level_difference = e1 - e2
    cond do
      -1 >= level_difference and level_difference >= -3 ->
        test_safe_incr([e2 | tail])
      true ->
        0
    end
  end


  def test_safe_decr([_e1]), do: 1

  def test_safe_decr([e1, e2 | tail]) do
    level_difference = e1 - e2
    cond do
      1 <= level_difference and level_difference <= 3 ->
        test_safe_decr([e2 | tail])
      true ->
        0
    end
  end

  def dampened_test_safe([e1, e2, e3 | tail]) do
    level_difference = e1 - e2
    cond do
      -1 >= level_difference and level_difference >= -3 ->
        dampened_test_safe_incr([e2, e3 | tail])
      1 <= level_difference and level_difference <= 3 ->
        dampened_test_safe_decr([e2, e3 | tail])
      -1 >= (e1 - e3) and (e1 - e3) >= -3 ->
        dampened_test_safe_incr([e2, e3 | tail])
      1 <= (e1 - e3) and (e1 - e3) > 3 ->
        dampened_test_safe_decr([e1, e3 | tail])
      true ->
        test_safe([e1, e3 | tail])
    end
  end


  def dampened_test_safe_incr([_e1]), do: 1

  def dampened_test_safe_incr([e1, e2 | tail]) do
    level_difference = e1 - e2
    cond do
      -1 >= level_difference and level_difference >= -3 ->
        dampened_test_safe_incr([e2 | tail])
      level_difference > 0 -> # shift down
        test_safe_incr([e2 | tail])
      level_difference <= 0 -> # jump up or plateau
        test_safe_incr([e1 | tail])
    end
  end


  def dampened_test_safe_decr([_e1]), do: 1

  def dampened_test_safe_decr([e1, e2 | tail]) do
    level_difference = e1 - e2
    cond do
      1 <= level_difference and level_difference <= 3 ->
        dampened_test_safe_decr([e2 | tail])
      level_difference <= 0 -> # shift up
        test_safe_decr([e2 | tail])
      level_difference > 0 -> # jump down or plateau
        test_safe_decr([e1 | tail])
    end
  end
end
