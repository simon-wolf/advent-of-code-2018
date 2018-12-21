defmodule AdventOfCode2018.Day14Test do
  use ExUnit.Case

  import AdventOfCode2018.Day14

  test "part1 after 9 recipies" do
    result = part1(9)
    assert result == "5158916779"
  end

  test "part1 after 5 recipies" do
    result = part1(5)
    assert result == "0124515891"
  end

  test "part1 after 18 recipies" do
    result = part1(18)
    assert result == "9251071085"
  end

  test "part1 after 2018 recipies" do
    result = part1(2018)
    assert result == "5941429882"
  end

  @tag :skip
  test "part2" do
    input = nil 
    result = part2(input)

    assert result
  end
end
