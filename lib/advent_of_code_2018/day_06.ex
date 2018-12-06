defmodule ChronalCoordinates do
  defstruct x: -1, y: -1, id: -1, infinite?: false
end

defmodule AdventOfCode2018.Day06 do
  @moduledoc false

  @doc """
  --- Day 6: Chronal Coordinates ---

  The device on your wrist beeps several times, and once again you feel like 
  you're falling.

  "Situation critical," the device announces. "Destination indeterminate. 
  Chronal interference detected. Please specify new target coordinates."

  The device then produces a list of coordinates (your puzzle input). Are they 
  places it thinks are safe or dangerous? It recommends you check manual page 
  729. The Elves did not give you a manual.

  If they're dangerous, maybe you can minimize the danger by finding the 
  coordinate that gives the largest distance from the other points.

  Using only the Manhattan distance, determine the area around each coordinate 
  by counting the number of integer X,Y locations that are closest to that 
  coordinate (and aren't tied in distance to any other coordinate).

  Your goal is to find the size of the largest area that isn't infinite. For 
  example, consider the following list of coordinates:

  1, 1
  1, 6
  8, 3
  3, 4
  5, 5
  8, 9

  If we name these coordinates A through F, we can draw them on a grid, putting 
  0,0 at the top left:

  ..........
  .A........
  ..........
  ........C.
  ...D......
  .....E....
  .B........
  ..........
  ..........
  ........F.

  This view is partial - the actual grid extends infinitely in all directions. 
  Using the Manhattan distance, each location's closest coordinate can be 
  determined, shown here in lowercase:

  aaaaa.cccc
  aAaaa.cccc
  aaaddecccc
  aadddeccCc
  ..dDdeeccc
  bb.deEeecc
  bBb.eeee..
  bbb.eeefff
  bbb.eeffff
  bbb.ffffFf

  Locations shown as . are equally far from two or more coordinates, and so 
  they don't count as being closest to any.

  In this example, the areas of coordinates A, B, C, and F are infinite - while 
  not shown here, their areas extend forever outside the visible grid. However, 
  the areas of coordinates D and E are finite: D is closest to 9 locations, and 
  E is closest to 17 (both including the coordinate's location itself). 
  Therefore, in this example, the size of the largest area is 17.

  What is the size of the largest area that isn't infinite?
  """
  def part1(file_path) do
    coords = file_path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> parse_coordinate_strings()
    
    outer_coords = outer_coordinates(coords)

    coords = flag_infinite(coords, outer_coords)

    min_x = Map.get(outer_coords, :min_x, 0)
    max_x = Map.get(outer_coords, :max_x, 0)
    min_y = Map.get(outer_coords, :min_y, 0)
    max_y = Map.get(outer_coords, :max_y, 0)

    locations = Enum.reduce(min_x..max_x, %{}, fn x_position, x_acc ->
      Enum.reduce(min_y..max_y, x_acc, fn y_position, y_acc ->
        Enum.reduce(coords, y_acc, fn coord, coord_acc ->
          # Get the existing map data or create new data
          {stored_coordinate_id, stored_distance} = Map.get(coord_acc, {x_position, y_position}, {-1, -1})

          # Get the distance between the point and the coordinate
          dist = manhattan_distance(x_position, y_position, Map.get(coord, :x), Map.get(coord, :y))

          {new_co_ord_id, new_distance} = cond do
            stored_distance == -1 ->
              {Map.get(coord, :id), dist}
            dist < stored_distance ->
              {Map.get(coord, :id), dist}
            dist == stored_distance ->
              {0, stored_distance}
            dist > stored_distance ->
              {stored_coordinate_id, stored_distance}
          end

          Map.put(coord_acc, {x_position, y_position}, {new_co_ord_id, new_distance})
        end)
      end)
    end)
    |> Map.values
    |> Enum.reduce(%{}, fn {owner, distance}, acc ->
      count = Map.get(acc, owner, 0)
      Map.put(acc, owner, count + 1)
    end)

    Enum.reduce(coords, 0, fn coord, acc -> 
      # if coord.infinite? == false do
      #   count = Map.get(locations, coord.id)
      #   if count > acc do
      #     count
      #   else
      #     acc
      #   end
      # else
      #   acc
      # end

      if coord.infinite? == false do
        IO.inspect Map.get(locations, coord.id), label: "Not Infinite"
      else
        IO.inspect Map.get(locations, coord.id), label: "Infinite"
      end
      0
    end)
  end

  def part2(args) do
  end

  # Convert the string coordinate values into ChronalCoordinates strucs
  defp parse_coordinate_strings(raw_coordinates) do
    raw_coordinates
    |> Enum.reduce([], fn coordinate_pair, acc -> 
      coords = coordinate_pair
      |> String.split(",")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple

      [ %ChronalCoordinates{x: elem(coords, 0), y: elem(coords, 1), id: length(acc) + 1} ] ++ acc
    end)
    |> Enum.reverse()
  end

  # Calculate the outer coordinates for a 'containing box'
  defp outer_coordinates(coordinates) do
    min_x = Enum.min_by(coordinates, fn coord -> Map.get(coord, :x) end) |> Map.get(:x)
    min_y = Enum.min_by(coordinates, fn coord -> Map.get(coord, :y) end) |> Map.get(:y)
    max_x = Enum.max_by(coordinates, fn coord -> Map.get(coord, :x) end) |> Map.get(:x)
    max_y = Enum.max_by(coordinates, fn coord -> Map.get(coord, :y) end) |> Map.get(:y)
    %{:min_x => min_x, :min_y => min_y, :max_x => max_x, :max_y => max_y}
  end

  # Update the ChronalCoordinates structs to say if an item is on the edge of
  # the 'containing box' and therefore infinitely big
  defp flag_infinite(coordinates, outer_coords) do
    Enum.map(coordinates, fn cc -> 
      Map.put(cc, :infinite?, is_infinite?(cc, outer_coords))
    end)
  end
  defp is_infinite?(%ChronalCoordinates{x: x, y: y}, %{min_x: min_x, min_y: min_y, max_x: max_x, max_y: max_y}) when x <= min_x or y <= min_y or x >= max_x or y >= max_y do
    true
  end
  defp is_infinite?(_, _) do
    false
  end

  # Manhattan distance between two coordinates
  def manhattan_distance(start_x, start_y, end_x, end_y) do
    abs(start_x - end_x) + abs(start_y - end_y)
  end
end
