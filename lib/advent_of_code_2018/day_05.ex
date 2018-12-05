defmodule AdventOfCode2018.Day05 do
  @moduledoc false

  @doc """
  --- Day 5: Alchemical Reduction ---

  You've managed to sneak in to the prototype suit manufacturing lab. The Elves 
  are making decent progress, but are still struggling with the suit's size 
  reduction capabilities.

  While the very latest in 1518 alchemical technology might have solved their 
  problem eventually, you can do better. You scan the chemical composition of 
  the suit's material and discover that it is formed by extremely long polymers 
  (one of which is available as your puzzle input).

  The polymer is formed by smaller units which, when triggered, react with each 
  other such that two adjacent units of the same type and opposite polarity are 
  destroyed. Units' types are represented by letters; units' polarity is 
  represented by capitalization. For instance, r and R are units with the same 
  type but opposite polarity, whereas r and s are entirely different types and 
  do not react.

  For example:

  In aA, a and A react, leaving nothing behind.
  In abBA, bB destroys itself, leaving aA. As above, this then destroys itself, leaving nothing.
  In abAB, no two adjacent units are of the same type, and so nothing happens.
  In aabAAB, even though aa and AA are of the same type, their polarities match, and so nothing happens.

  Now, consider a larger example, dabAcCaCBAcCcaDA:

  dabAcCaCBAcCcaDA  The first 'cC' is removed.
  dabAaCBAcCcaDA    This creates 'Aa', which is removed.
  dabCBAcCcaDA      Either 'cC' or 'Cc' are removed (the result is the same).
  dabCBAcaDA        No further actions can be taken.

  After all possible reactions, the resulting polymer contains 10 units.

  How many units remain after fully reacting the polymer you scanned?
  """
  def part1(file_path) do
    polymer = file_path
    |> File.read!()

    scan_polymer(polymer, 0, String.length(polymer))
    |> String.length
  end

  @doc """
  --- Part Two ---

  Time to improve the polymer.

  One of the unit types is causing problems; it's preventing the polymer from 
  collapsing as much as it should. Your goal is to figure out which unit type 
  is causing the most problems, remove all instances of it (regardless of 
  polarity), fully react the remaining polymer, and measure its length.

  For example, again using the polymer dabAcCaCBAcCcaDA from above:

  - Removing all A/a units produces dbcCCBcCcD. Fully reacting this polymer 
    produces dbCBcD, which has length 6.
  - Removing all B/b units produces daAcCaCAcCcaDA. Fully reacting this polymer 
    produces daCAcaDA, which has length 8.
  - Removing all C/c units produces dabAaBAaDA. Fully reacting this polymer 
    produces daDA, which has length 4.
  - Removing all D/d units produces abAcCaCBAcCcaA. Fully reacting this polymer 
    produces abCBAc, which has length 6.

  In this example, removing all C/c units was best, producing the answer 4.

  What is the length of the shortest polymer you can produce by removing all 
  units of exactly one type and fully reacting the result?
  """
  def part2(file_path) do
    polymer = file_path
    |> File.read!()

    units = polymer
    |> String.upcase()
    |> String.graphemes()
    |> MapSet.new()
    |> MapSet.to_list()

    unit_totals = Enum.reduce(units, %{}, fn unit, acc -> 
      length = polymer
      |> String.replace(String.upcase(unit), "")
      |> String.replace(String.downcase(unit), "")
      |> scan_polymer(0, String.length(polymer))
      |> String.length
      
      Map.put(acc, unit, length)
    end)

    {_unit, polymer_length} = units
    |> Enum.reduce({"", 100000}, fn unit, acc -> 
      character_count = Map.get(unit_totals, unit)
      if character_count < elem(acc, 1) do
        {unit, character_count}
      else
        acc
      end
    end)
    
    polymer_length
  end


  defp scan_polymer(polymer, index, length) when index < (length - 1) do
    polymer
    |> String.slice(index, 2)
    |> String.graphemes()

    prefix = prefix(polymer, index)

    suffix = suffix(polymer, index, length)

    scanned_polymer = merge(String.slice(polymer, index, 1), String.slice(polymer, index + 1, 1))

    new_polymer = prefix <> scanned_polymer <> suffix
    new_polymer_length = String.length(new_polymer)

    new_index = if length > new_polymer_length do
      if index > 1 do
        index - 1
      else
        0
      end
    else
      index + 1
    end

    scan_polymer(new_polymer, new_index, String.length(new_polymer))
  end
  defp scan_polymer(polymer, _index, _length), do: polymer
  
  defp prefix(polymer, index) when index > 0, do: String.slice(polymer, 0..index - 1)
  defp prefix(_polymer, _index), do: ""

  defp suffix(polymer, index, length) when index + 2 < length, do: String.slice(polymer, index + 2..-1)
  defp suffix(_polymer, _index, _length), do: ""

  defp merge(first, second), do: merge(first, second, String.upcase(first), String.upcase(second))
  defp merge(first, second, upcase_first, upcase_second) when upcase_first == upcase_second and first != second, do: ""
  defp merge(first, second, _upcase_first, _upcase_second), do: first <> second

end
