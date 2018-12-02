defmodule AdventOfCode2018.Day01Test do
  use ExUnit.Case

  import AdventOfCode2018.Day01

  test "part1" do
    file_path = "/Users/simon/Development/Elixir/advent-of-code/data/day_01_task_01_test_01.txt"
    {:ok, items} = File.read(file_path)
    result = part1(items)

    assert result == 3
  end

  test "part2-01" do
    file_path = "/Users/simon/Development/Elixir/advent-of-code/data/day_01_task_02_test_01.txt"
    {:ok, items} = File.read(file_path)
    result = part2(items)

    assert result == 2
  end

  test "part2-02" do
    file_path = "/Users/simon/Development/Elixir/advent-of-code/data/day_01_task_02_test_02.txt"
    {:ok, items} = File.read(file_path)
    result = part2(items)

    assert result == 0
  end

  test "part2-03" do
    file_path = "/Users/simon/Development/Elixir/advent-of-code/data/day_01_task_02_test_03.txt"
    {:ok, items} = File.read(file_path)
    result = part2(items)

    assert result == 10
  end

  test "part2-04" do
    file_path = "/Users/simon/Development/Elixir/advent-of-code/data/day_01_task_02_test_04.txt"
    {:ok, items} = File.read(file_path)
    result = part2(items)

    assert result == 5
  end

  test "part2-05" do
    file_path = "/Users/simon/Development/Elixir/advent-of-code/data/day_01_task_02_test_05.txt"
    {:ok, items} = File.read(file_path)
    result = part2(items)

    assert result == 14
  end

end
