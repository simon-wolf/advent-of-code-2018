defmodule AdventOfCode2018.Day06Test do
  use ExUnit.Case

  import AdventOfCode2018.Day06

  test "part1" do
    file_path = "./data/day_06_task_01_test_01.txt"
    result = part1(file_path)
    assert result == 17
  end

  @tag :skip
  test "part2" do
    input = nil 
    result = part2(input)

    assert result
  end
end
