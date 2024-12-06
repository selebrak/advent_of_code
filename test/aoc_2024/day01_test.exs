defmodule Aoc2024.Day01Test do
  use ExUnit.Case
  #TODO doctest Aoc2024.Day01

  import Aoc2024.Day01

  test "Day 01 Star 1" do
    assert part1() == 1506483
  end

  test "Day 01 Star 2" do
    assert part2() == 23126924
  end
end
