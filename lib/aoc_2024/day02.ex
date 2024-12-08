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
    |> count_safe_reports(:undampened)
  end

  def part2() do
    @input_filepath
    |> read_in_reports()
    |> count_safe_reports(:dampened)
  end

  # returns a Stream of reports
  def read_in_reports(filepath) do
    filepath
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split/1)
    |> Stream.map(fn report -> Enum.map(report, &String.to_integer/1) end)
  end

  def count_safe_reports(reports, dampened? \\ :undampened) do
    reports
    |> Task.async_stream(fn report -> report_safe?(report, dampened?) end)
    |> Stream.map(fn {:ok, result} -> result end)
    |> Enum.sum()
  end

  def generate_diffs(list) do
    list
    |> Enum.zip(Kernel.tl(list))
    |> Enum.map(fn {x,y} -> x - y end)
  end

  def pos_bounded?(list) do
    generate_diffs(list)
    |> Enum.all?(fn x -> x in 1..3 end)
  end

  def neg_bounded?(list) do
    generate_diffs(list)
    |> Enum.all?(fn x -> x in -1..-3//-1 end)
  end

  def all_bounded?(report) do
    tasks = [
      Task.async(fn -> pos_bounded?(report) end),
      Task.async(fn -> neg_bounded?(report) end)
    ]

    results =
      tasks
      |> Task.await_many() #TODO use a Duration here?

    [ pos_bounded, neg_bounded ] = results

    if pos_bounded || neg_bounded, do: 1, else: 0
  end

  def report_safe?(report, dampened? \\ :undampened) do
    if dampened? == :undampened do
      all_bounded?(report)
    else
      # We naively attempt to delete each element and re-check without it
      # If any attempts are bounded, then the report is safe
      bounded_attempts =
        0..(Kernel.length(report) - 1)
        |> Task.async_stream(fn index ->
          report
          |> List.delete_at(index)
          |> all_bounded?()
        end)
        |> Enum.reduce(0, fn {:ok, result}, acc -> acc + result end)

      if bounded_attempts > 0, do: 1, else: 0
    end
  end
end
