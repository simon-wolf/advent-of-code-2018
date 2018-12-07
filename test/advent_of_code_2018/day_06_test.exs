defmodule AdventOfCode2018.Day06Test do
  use ExUnit.Case

  import AdventOfCode2018.Day06

  test "part1" do
    file_path = "./data/day_06_task_01_test_01.txt"
    result = part1(file_path)
    assert result == 17
  end

  test "part2" do
    file_path = "./data/day_06_task_01_test_01.txt"
    result = part2(file_path, 32)
    assert result == 16
  end
end
