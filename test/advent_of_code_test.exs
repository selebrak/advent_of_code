defmodule AdventOfCodeTest do
  use ExUnit.Case
  #TODO doctest AdventOfCode

  @base_inputs_path Path.expand("../priv/inputs/2024", __DIR__)
  @day01_input_path Path.join(@base_inputs_path, "day-01-input.txt")

  test "Day 01 Star 1" do
    {list1, list2} = AdventOfCode.lists_from_file(@day01_input_path)
    assert AdventOfCode.inter_list_distance(list1, list2) == 1506483
  end

  test "Day 01 Star 2" do
    {list1, list2} = AdventOfCode.lists_from_file(@day01_input_path)
    assert AdventOfCode.similarity_score(list1, list2) == 23126924
  end
end
