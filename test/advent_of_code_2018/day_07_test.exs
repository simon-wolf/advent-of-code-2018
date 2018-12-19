defmodule AdventOfCode2018.Day07Test do
  use ExUnit.Case

  import AdventOfCode2018.Day07

  @tag :skip
  test "part1" do
    file_path = "./data/day_07_task_01_test_01.txt"
    result = part1(file_path)
    assert result == "CABDFE"
  end

  test "part2" do
    file_path = "./data/day_07_task_01_test_01.txt"
    {_, result} = part2(file_path)
    assert result == 253
  end
end
