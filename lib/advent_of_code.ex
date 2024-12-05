defmodule AdventOfCode do
  @moduledoc """
  Documentation for `AdventOfCode`.
  """

  @doc """
  Day one!

  ## Examples

      iex> AdventOfCode.day1()
      <distance between lists>

  """
  def inter_list_distance(list1, list2) do
    sorted_list1 = Enum.sort(list1)
    sorted_list2 = Enum.sort(list2)

    sorted_list1
    |> Enum.zip(sorted_list2)
    |> Enum.map(fn {x,y} -> abs(x - y) end)
    |> Enum.reduce(0, &+/2) # or Enum.sum()
  end

  def read_file(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(fn [x, y] -> {x, y} end)
    |> Enum.unzip()
  end
end
