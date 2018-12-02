defmodule AdventOfCode2018.Day01 do
  def part1(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn x -> String.to_integer(x) end)
    |> Enum.sum()
  end

  def part2(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn x -> String.to_integer(x) end)
    |> Stream.cycle()
    |> Enum.reduce_while({0, MapSet.new([0])}, fn x, {current_frequency, recorded_frequencies} ->
      new_frequency = current_frequency + x
      if MapSet.member?(recorded_frequencies, new_frequency), do: {:halt, new_frequency}, else: {:cont, {new_frequency, MapSet.put(recorded_frequencies, new_frequency)}}
    end)
  end
end
