defmodule AdventOfCode2018.Day11Test do
  use ExUnit.Case
  doctest AdventOfCode2018.Day11

  import AdventOfCode2018.Day11

  @tag :skip
  test "part1 with serial number 18" do
    assert {{33, 45}, 3, 29} = part1(18)
  end

  @tag :skip
  test "part1 with serial number 42" do
    assert {{21, 61}, 3, 30} = part1(42)
  end

  @tag :skip
  test "part2 with serial number 18" do
    assert {{90, 269}, 16, 113} = part2(18)
  end

  @tag :skip
  test "part2 with serial number 42" do
    assert {{232, 251}, 12, 119} = part2(42)
  end

end
