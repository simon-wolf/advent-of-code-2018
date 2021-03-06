defmodule AdventOfCode2018.Day03Test do
  use ExUnit.Case

  import AdventOfCode2018.Day03

  test "part1" do
    file_path = "./data/day_03_task_01_test_01.txt"
    result = part1(file_path)
    assert result == 4
  end

  test "part2" do
    file_path = "./data/day_03_task_01_test_01.txt"
    result = part2(file_path)
    assert result == 3
  end
end
