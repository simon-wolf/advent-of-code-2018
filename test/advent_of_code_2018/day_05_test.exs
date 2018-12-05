defmodule AdventOfCode2018.Day05Test do
  use ExUnit.Case

  import AdventOfCode2018.Day05

  test "part1 - two polymers which cancel each other" do
    file_path = "./data/day_05_task_01_test_01.txt"
    result = part1(file_path)
    assert result == 0
  end

  test "part1 - four polymers which cancel each other" do
    file_path = "./data/day_05_task_01_test_02.txt"
    result = part1(file_path)
    assert result == 0
  end

  test "part1 - four polymers which do not cancel each other" do
    file_path = "./data/day_05_task_01_test_03.txt"
    result = part1(file_path)
    assert result == 4
  end

  test "part1 - six polymers which do not cancel each other" do
    file_path = "./data/day_05_task_01_test_04.txt"
    result = part1(file_path)
    assert result == 6
  end

  test "part1 - fifteen polymers which cancel down to ten" do
    file_path = "./data/day_05_task_01_test_05.txt"
    result = part1(file_path)
    assert result == 10
  end

  test "part2" do
    file_path = "./data/day_05_task_02_test_01.txt"
    result = part2(file_path)
    assert result == 4
  end
end
