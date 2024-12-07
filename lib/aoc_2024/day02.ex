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
    count_safe_reports(@input_filepath, &report_safe?/1)
  end

  def part2() do
    count_safe_reports(@input_filepath, &dampened_report_safe?/1)
  end

  def count_safe_reports(filepath, check_function) do
    # TODO move file reading and data massaging into separate function?
    filepath
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split/1)
    |> Stream.map(fn report -> Enum.map(report, &String.to_integer/1) end)
    |> Task.async_stream(check_function)
    |> Stream.map(fn {:ok, result} -> result end)
    |> Enum.sum()
  end

  def report_safe?([e1, e2 | tail]) do
    diff = e1 - e2
    cond do
      diff in -1..-3//-1 ->
        safe_up?([e2 | tail])
      diff in 1..3//1 ->
        safe_down?([e2 | tail])
      true ->
        0
    end
  end

  def safe_up?([_e1]), do: 1

  def safe_up?([e1, e2 | tail]) do
    diff = e1 - e2
    cond do
      diff in -1..-3//-1 ->
        safe_up?([e2 | tail])
      true ->
        0
    end
  end

  def safe_down?([_e1]), do: 1

  def safe_down?([e1, e2 | tail]) do
    diff = e1 - e2
    cond do
      diff in 1..3//1 ->
        safe_down?([e2 | tail])
      true ->
        0
    end
  end

  def dampened_report_safe?([_e1]), do: 1

  # only two items left and we've not dampened a problem - report must be safe
  def dampened_report_safe?([e1, e2]) do
    1
  end

  def dampened_report_safe?([e1, e2 | tail]) do
    diff = e1 - e2
    cond do
      diff in -1..-3//-1 ->
        dampened_safe_up?([e2 | tail])
      diff in 1..3//1 ->
        dampened_safe_down?([e2 | tail])
      true ->
        remove_unsafe(e1, e2, hd(tail)) ++ tail
        |> report_safe?()
    end
  end

  def dampened_safe_up?([_e1]), do: 1

  def dampened_safe_up?([e1, e2]) do
    safe_up?([e1, e2])
  end

  def dampened_safe_up?([e1, e2 | tail]) do
    diff = e1 - e2
    cond do
      diff in -1..-3//-1 ->
        dampened_safe_up?([e2 | tail])
      true ->
        remove_unsafe(e1, e2, hd(tail)) ++ tail
        |> safe_up?()
    end
  end

  def dampened_safe_down?([_e1]), do: 1

  def dampened_safe_down?([e1, e2]) do
    safe_down?([e1, e2])
  end

  def dampened_safe_down?([e1, e2 | tail]) do
    diff = e1 - e2
    cond do
      diff in 1..3//1 ->
        dampened_safe_down?([e2 | tail])
      true ->
        remove_unsafe(e1, e2, hd(tail)) ++ tail
        |> safe_down?()
    end
  end
  # returns a list of the two elements we should keep
  def remove_unsafe(e1, e2, e3, direction \\ :none) do
    diff_p1 = e1 - e2
    diff_p2 = e2 - e3

    case direction do
      :up ->
        cond do
          diff_p1 >= 0 ->
            [e2, e3]
          diff_p2 >= 0 ->
            [e1, e3]
          true ->
            [e1, e2]
        end
      :down ->
        cond do
          diff_p1 <= 0 ->
            [e2, e3]
          diff_p2 <= 0 ->
            [e1, e2]
          true ->
            [e1, e3]
        end
      :none ->
        cond do
          diff_p1 == 0 || diff_p2 == 0 ->
            [e2, e3]
          diff_p1 > 3 || diff_p2 < -3 ->
            [e2, e3]
          diff_p1 < -3 || diff_p2 > 3 ->
            [e1, e3]
          true ->
            [e1, e3]
        end
    end
  end
end
