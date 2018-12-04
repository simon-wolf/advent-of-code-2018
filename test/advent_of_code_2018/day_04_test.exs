defmodule AdventOfCode2018.Day04Test do
  use ExUnit.Case

  import AdventOfCode2018.Day04

  test "part1" do
    file_path = "./data/day_04_task_01_test_01.txt"
    result = part1(file_path)
    assert result == 240
  end

  @tag :skip
  test "part2" do
    input = nil 
    result = part2(input)

    assert result
  end
end
