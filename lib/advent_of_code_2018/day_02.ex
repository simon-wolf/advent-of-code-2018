defmodule AdventOfCode2018.Day02 do
  def part1(file_path) do
    summary = file_path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
		|> Enum.to_list()
		|> Enum.map(&AdventOfCode2018.Day02.splitter/1)

		count_of_twos = Enum.count(summary, fn x -> MapSet.member?(x, 2) end)
		count_of_threes = Enum.count(summary, fn x -> MapSet.member?(x, 3) end)
		count_of_twos * count_of_threes
  end

  def part2(args) do
  end

  def splitter(letters) do
		letters
		|> String.graphemes()
		|> Enum.reduce(%{}, fn char, acc ->
			Map.update(acc, char, 1, &(&1 + 1))
		end)
		|> Map.values()
		|> MapSet.new()
	end

end
