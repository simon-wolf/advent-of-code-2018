defmodule AdventOfCode2018.Day08 do
  @moduledoc false

  @doc """
  --- Day 8: Memory Maneuver ---

  The sleigh is much easier to pull than you'd expect for something its weight. 
  Unfortunately, neither you nor the Elves know which way the North Pole is 
  from here.

  You check your wrist device for anything that might help. It seems to have 
  some kind of navigation system! Activating the navigation system produces 
  more bad news: "Failed to start navigation system. Could not read software 
  license file."

  The navigation system's license file consists of a list of numbers (your 
  puzzle input). The numbers define a data structure which, when processed, 
  produces some kind of tree that can be used to calculate the license number.

  The tree is made up of nodes; a single, outermost node forms the tree's root, 
  and it contains all other nodes in the tree (or contains nodes that contain 
  nodes, and so on).

  Specifically, a node consists of:

  - A header, which is always exactly two numbers:
  - The quantity of child nodes.
  - The quantity of metadata entries.
  - Zero or more child nodes (as specified in the header).
  - One or more metadata entries (as specified in the header).
  - Each child node is itself a node that has its own header, child nodes, and 
    metadata. For example:

  2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
  A----------------------------------
      B----------- C-----------
                      D-----

  In this example, each node of the tree is also marked with an underline 
  starting with a letter for easier identification. In it, there are four 
  nodes:

  A, which has 2 child nodes (B, C) and 3 metadata entries (1, 1, 2).
  B, which has 0 child nodes and 3 metadata entries (10, 11, 12).
  C, which has 1 child node (D) and 1 metadata entry (2).
  D, which has 0 child nodes and 1 metadata entry (99).

  The first check done on the license file is to simply add up all of the 
  metadata entries. In this example, that sum is 1+1+2+10+11+12+2+99=138.

  What is the sum of all metadata entries?
  """
  def part1(file_path) do
    file_path
    |> File.read!()
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    # |> drill_down([])
    # |> Enum.sum()
    |> reduce([], [])
    |> Enum.sum()
  end

  def part2(_file_path) do
  end

  # headers is an array of headers
  defp reduce([0, count_of_metadata | tail] = metadata, [ {1, remainder} | other_headers], tally) do
    metadata = Enum.slice(tail, 0..(count_of_metadata - 1 + remainder))
    tally = metadata ++ tally

    remainder = Enum.slice(tail, count_of_metadata..-1 + remainder)
    # remainder = Enum.slice(tail, count_of_metadata..-1)

    IO.puts "0"
    IO.inspect remainder
    IO.inspect other_headers
    IO.inspect tally
    IO.puts "---"
    reduce(remainder, other_headers, tally)
  end



  defp reduce(metadata, [ {1, remainder} | other_headers], tally) do
    new_metadata = Enum.slice(metadata, 0..(remainder - 1))
    tally = metadata ++ tally

    new_remainder = Enum.slice(metadata, remainder..-1)

    IO.puts "1"
    IO.inspect new_remainder
    IO.inspect other_headers
    IO.inspect tally
    IO.puts "---"
    reduce(new_remainder, other_headers, tally)
  end



  defp reduce([0, count_of_metadata | tail] = metadata, [ {children, remainder} | other_headers], tally) do
    new_headers = [{ children - 1, remainder}] ++ other_headers

    metadata = Enum.slice(tail, 0..(count_of_metadata - 1))
    tally = metadata ++ tally

    remainder = Enum.slice(tail, count_of_metadata..-1)

    IO.puts "2"
    IO.inspect remainder
    IO.inspect new_headers
    IO.inspect tally
    IO.puts "---"
    reduce(remainder, new_headers, tally)
  end

  defp reduce([count_of_children, count_of_metadata | tail] = metadata, headers, tally) do
    new_headers = [{ count_of_children, count_of_metadata}] ++ headers

    IO.puts "3"
    IO.inspect tail
    IO.inspect new_headers
    IO.inspect tally
    IO.puts "---"
    reduce(tail, new_headers, tally)
  end

  defp reduce(_, [], tally) do
    IO.puts "4"
    tally
  end

  
  # defp drill_down([0, count_of_metadata | tail] = numbers, tally) do
  #   metadata = Enum.slice(tail, 0..(count_of_metadata - 1))
  #   tally = metadata ++ tally

  #   remainder = Enum.slice(tail, count_of_metadata..-1)

  #   IO.inspect metadata, label: "metadata"
  #   IO.inspect remainder, label: "remainder"

  #   drill_down(remainder, tally)
  # end


  # defp drill_down([count_of_children, count_of_metadata | tail] = numbers, tally) do
  #   metadata = tail
  #   |> Enum.reverse()
  #   |> Enum.take(count_of_metadata)
  #   |> Enum.reverse()

  #   tally = metadata ++ tally

  #   remainder = Enum.slice(tail, 0..(count_of_metadata + 1) * -1)

  #   IO.inspect metadata, label: "metadata"
  #   IO.inspect remainder, label: "remainder"

  #   drill_down(remainder, tally)
  # end

  # defp drill_down([], tally) do
  #   tally
  # end

end
