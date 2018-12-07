defmodule AdventOfCode2018.Day07Test do
  use ExUnit.Case

  import AdventOfCode2018.Day07

  test "part1" do
    file_path = "./data/day_07_task_01_test_01.txt"
    result = part1(file_path)
    assert result == "CABDFE"
  end

  @tag :skip
  test "part2" do
    input = nil 
    result = part2(input)

    assert result
  end
end
