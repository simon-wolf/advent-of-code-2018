defmodule AdventOfCode2018.Day11Test do
  use ExUnit.Case
  doctest AdventOfCode2018.Day11

  import AdventOfCode2018.Day11

  test "part1 with serial number 18" do
    assert {{33, 45}, 3, 29} = part1(18)
  end

  test "part1 with serial number 42" do
    assert {{21, 61}, 3, 30} = part1(42)
  end

  @tag :skip
  test "part2" do
    input = nil 
    result = part2(input)

    assert result
  end
end
