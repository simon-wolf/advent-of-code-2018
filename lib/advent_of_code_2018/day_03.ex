defmodule AdventOfCode2018.Day03 do
  @moduledoc false

  @doc """
  --- Day 3: No Matter How You Slice It ---

  The Elves managed to locate the chimney-squeeze prototype fabric for Santa's
  suit (thanks to someone who helpfully wrote its box IDs on the wall of the
  warehouse in the middle of the night). Unfortunately, anomalies are still
  affecting them - nobody can even agree on how to cut the fabric.

  The whole piece of fabric they're working on is a very large square - at
  least 1000 inches on each side.

  Each Elf has made a claim about which area of fabric would be ideal for
  Santa's suit. All claims have an ID and consist of a single rectangle with
  edges parallel to the edges of the fabric. Each claim's rectangle is defined
  as follows:

  - The number of inches between the left edge of the fabric and the left edge
    of the rectangle.
  - The number of inches between the top edge of the fabric and the top edge
    of the rectangle.
  - The width of the rectangle in inches.
  - The height of the rectangle in inches.

  A claim like #123 @ 3,2: 5x4 means that claim ID 123 specifies a rectangle 3
  inches from the left edge, 2 inches from the top edge, 5 inches wide, and 4
  inches tall. Visually, it claims the square inches of fabric represented by
  # (and ignores the square inches of fabric represented by .) in the diagram
  below:

  ...........
  ...........
  ...#####...
  ...#####...
  ...#####...
  ...#####...
  ...........
  ...........
  ...........

  The problem is that many of the claims overlap, causing two or more claims to
  cover part of the same areas. For example, consider the following claims:

  #1 @ 1,3: 4x4
  #2 @ 3,1: 4x4
  #3 @ 5,5: 2x2

  Visually, these claim the following areas:

  ........
  ...2222.
  ...2222.
  .11XX22.
  .11XX22.
  .111133.
  .111133.
  ........

  The four square inches marked with X are claimed by both 1 and 2. (Claim 3,
  while adjacent to the others, does not overlap either of them.)

  If the Elves all proceed with their own plans, none of them will have enough
  fabric. How many square inches of fabric are within two or more claims?
  """
  def part1(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
    |> coordinates_from_list()
    |> Enum.filter( fn {_, value} -> value > 1  end)
    |> Enum.count()
  end

  @doc """
  --- Part Two ---

  Amidst the chaos, you notice that exactly one claim doesn't overlap by even
  a single square inch of fabric with any other claim. If you can somehow draw
  attention to it, maybe the Elves will be able to make Santa's suit after all!

  For example, in the claims above, only claim 3 is intact after all claims are made.

  What is the ID of the only claim that doesn't overlap?
  """
  def part2(file_path) do
    area_strings = file_path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()

    invalid_coords = area_strings
    |> coordinates_from_list()
    |> Enum.filter( fn {_, value} -> value > 1  end)
    |> Enum.reduce(MapSet.new(), fn {coord, _}, acc ->
      MapSet.put(acc, coord)
    end)
    |> MapSet.to_list()

    area_strings
    |> valid_coordinates_from_list(invalid_coords)
  end

  defp valid_coordinates_from_list(areas_list, invalid_coords) do
    invalid_map = MapSet.new(invalid_coords)

    Enum.reduce_while(areas_list, nil, fn position, _ ->
      area = Regex.named_captures(~r/^#(?<id>\d+) @ (?<x>\d+),(?<y>\d+): (?<w>\d+)x(?<h>\d+)$/, position)
      x_value = String.to_integer(area["x"])
      y_value = String.to_integer(area["y"])
      w_value = String.to_integer(area["w"])
      h_value = String.to_integer(area["h"])
      id_value = String.to_integer(area["id"])

      coords = for x_position <- x_value..(x_value + w_value - 1), y_position <- y_value..(y_value + h_value - 1), do: {x_position, y_position}
      coords_map = MapSet.new(coords)
      intersection = MapSet.intersection(coords_map, invalid_map)
      if MapSet.size(intersection) == 0, do: {:halt, id_value}, else: {:cont, 0}
    end)
  end

  defp coordinates_from_list(areas_list) do
    areas_list
    |> Enum.reduce(%{}, fn position, areas ->
      area = Regex.named_captures(~r/^#(?<id>\d+) @ (?<x>\d+),(?<y>\d+): (?<w>\d+)x(?<h>\d+)$/, position)
      x_value = String.to_integer(area["x"])
      y_value = String.to_integer(area["y"])
      w_value = String.to_integer(area["w"])
      h_value = String.to_integer(area["h"])

      coords = for x_position <- x_value..(x_value + w_value - 1), y_position <- y_value..(y_value + h_value - 1), do: {x_position, y_position}
      new_map = Enum.reduce(coords, %{}, fn coord, acc ->
        Map.update(acc, coord, 1, &(&1 + 1))
      end)

      Map.merge(areas, new_map, fn _k, v1, v2 ->
        v1 + v2
      end)
    end)
    |> Map.to_list
  end

end
