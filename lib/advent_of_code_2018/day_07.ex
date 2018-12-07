defmodule AdventOfCode2018.Day07 do
  @moduledoc false

  @doc """
  --- Day 7: The Sum of Its Parts ---

  You find yourself standing on a snow-covered coastline; apparently, you 
  landed a little off course. The region is too hilly to see the North Pole 
  from here, but you do spot some Elves that seem to be trying to unpack 
  something that washed ashore. It's quite cold out, so you decide to risk 
  creating a paradox by asking them for directions.

  "Oh, are you the search party?" Somehow, you can understand whatever Elves 
  from the year 1018 speak; you assume it's Ancient Nordic Elvish. Could the 
  device on your wrist also be a translator? "Those clothes don't look very 
  warm; take this." They hand you a heavy coat.

  "We do need to find our way back to the North Pole, but we have higher 
  priorities at the moment. You see, believe it or not, this box contains 
  something that will solve all of Santa's transportation problems - at least, 
  that's what it looks like from the pictures in the instructions." It doesn't 
  seem like they can read whatever language it's in, but you can: "Sleigh kit. 
  Some assembly required."

  "'Sleigh'? What a wonderful name! You must help us assemble this 'sleigh' at 
  once!" They start excitedly pulling more parts out of the box.

  The instructions specify a series of steps and requirements about which steps 
  must be finished before others can begin (your puzzle input). Each step is 
  designated by a single letter. For example, suppose you have the following 
  instructions:

  Step C must be finished before step A can begin.
  Step C must be finished before step F can begin.
  Step A must be finished before step B can begin.
  Step A must be finished before step D can begin.
  Step B must be finished before step E can begin.
  Step D must be finished before step E can begin.
  Step F must be finished before step E can begin.

  Visually, these requirements look like this:

    -->A--->B--
  /    \      \
  C      -->D----->E
  \           /
    ---->F-----

  Your first goal is to determine the order in which the steps should be 
  completed. If more than one step is ready, choose the step which is first 
  alphabetically. In this example, the steps would be completed as follows:

  - Only C is available, and so it is done first.
  - Next, both A and F are available. A is first alphabetically, so it is done 
    next.
  - Then, even though F was available earlier, steps B and D are now also 
    available, and B is the first alphabetically of the three.
  - After that, only D and F are available. E is not available because only 
    some of its prerequisites are complete. Therefore, D is completed next.
  - F is the only choice, so it is done next.
  - Finally, E is completed.

  So, in this example, the correct order is CABDFE.

  In what order should the steps in your instructions be completed?
  """
  def part1(file_path) do
    dependencies_map = file_path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&parse_instruction/1)
    |> Enum.to_list()

    |> Enum.reduce(%{}, fn {do_this, before_this}, acc -> 
      acc = Map.put_new(acc, do_this, [])
      acc = Map.put_new(acc, before_this, [])

      dependencies = Map.get(acc, before_this)
      Map.put(acc, before_this, [do_this] ++ dependencies)
    end)

    parse_map([], dependencies_map, Map.keys(dependencies_map) |> length())
  end

  def part2(file_path) do
    _ = file_path
    |> File.stream!()
    |> Stream.map(&String.trim/1)

    ""
  end

  defp parse_instruction(instruction) do
    { String.slice(instruction, 5..5), String.slice(instruction, 36..36) }
  end


  defp parse_map(steps, dependencies_map, map_keys_count) when map_keys_count > 0 do
    next_step = next_available_step(dependencies_map)

    new_dependendencies_map = Enum.reduce(Map.keys(dependencies_map), %{}, fn key, acc -> 
      if key == next_step do
        acc
      else
        new_deps = Map.get(dependencies_map, key)
        |> List.delete(next_step)
        Map.put(acc, key, new_deps)
      end
    end)

    new_steps = [ next_step ] ++ steps

    new_count = Map.keys(new_dependendencies_map) |> length()

    parse_map(new_steps, new_dependendencies_map, new_count)
  end

  defp parse_map(steps, _dependencies_map, _map_keys_count) do
    Enum.reverse(steps) |> List.to_string()
  end



  defp next_available_step(dependencies_map) do
    Map.keys(dependencies_map)
    |> Enum.reduce([], fn key, acc -> 
      dependencies = Map.get(dependencies_map, key)
      if length(dependencies) == 0 do
        [key] ++ acc
      else
        acc
      end
    end)
    |> Enum.sort()
    |> List.first()
  end
end
