defmodule AdventOfCode2018.Day04Test do
  use ExUnit.Case

  import AdventOfCode2018.Day04

  test "part1" do
    file_path = "./data/day_04_task_01_test_01.txt"
    result = part1(file_path)
    assert result == 240
  end

  test "part2" do
    file_path = "./data/day_04_task_01_test_01.txt"
    result = part2(file_path)
    assert result == 4455
  end
end
