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

  def pos_bounded?(list, dampened?) do
    if dampened? == :undampened do
      Enum.all?(list, fn x -> x in 1..3 end)
    end
  end

  def neg_bounded?(list, dampened?) do
    if dampened? == :undampened do
      Enum.all?(list, fn x -> x in -1..-3//-1 end)
    end
  end

  def report_safe?(report, dampened? \\ :undampened) do
    diffs =
      report
      |> Enum.zip(Kernel.tl(report))
      |> Enum.map(fn {x,y} -> x - y end)

    tasks = [
      Task.async(fn -> pos_bounded?(diffs, dampened?) end),
      Task.async(fn -> neg_bounded?(diffs, dampened?) end)
    ]

    results =
      tasks
      |> Task.await_many() #TODO use a Duration here?

    [ pos_bounded, neg_bounded ] = results

    cond do
      pos_bounded || neg_bounded ->
        1
      true ->
        0
    end
  end
end
