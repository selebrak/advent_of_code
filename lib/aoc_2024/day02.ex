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
    @input_filepath
    |> read_in_reports()
    |> count_safe_reports(&report_safe?/1)
  end

  def part2() do
    @input_filepath
    |> read_in_reports()
    |> count_safe_reports(&dampened_report_safe?/1)
  end

  # returns a Stream of reports
  def read_in_reports(filepath) do
    filepath
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split/1)
  end

  def count_safe_reports(reports, check_function) do
    reports
    |> Stream.map(fn report -> Enum.map(report, &String.to_integer/1) end)
    |> Task.async_stream(check_function)
    |> Stream.map(fn {:ok, result} -> result end)
    |> Enum.sum()
  end

  def report_safe?(report) do
    diffs =
      report
      |> Enum.zip(Kernel.tl(report))
      |> Enum.map(fn {x,y} -> x - y end)

    # Check all four safety conditions concurrently
    tasks = [
      Task.async(fn -> Enum.all?(diffs, fn x -> x > 0 end) end),
      Task.async(fn -> Enum.all?(diffs, fn x -> x in 1..3 end) end),
      Task.async(fn -> Enum.all?(diffs, fn x -> x < 0 end) end),
      Task.async(fn -> Enum.all?(diffs, fn x -> x in -1..-3//-1 end) end)
    ]

    results =
      tasks
      |> Task.await_many() #TODO use a Duration here?

    [ all_pos, pos_bounded, all_neg, neg_bounded ] = results

    cond do
      all_pos && pos_bounded ->
        1
      all_neg && neg_bounded ->
        1
      true ->
        0
    end
  end
end
