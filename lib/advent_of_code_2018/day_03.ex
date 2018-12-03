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
    {_used, overlaps} = file_path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
    |> Enum.reduce({[], []}, fn position, {used, overlaps} ->
      area = Regex.named_captures(~r/^#(?<id>\d+) @ (?<x>\d+),(?<y>\d+): (?<w>\d+)x(?<h>\d+)$/, position)
      x_value = String.to_integer(area["x"])
      y_value = String.to_integer(area["y"])
      w_value = String.to_integer(area["w"])
      h_value = String.to_integer(area["h"])

      coords = for x_position <- x_value..(x_value + w_value - 1), y_position <- y_value..(y_value + h_value - 1), do: {x_position, y_position}

      coords_mapset = MapSet.new(coords)
      used_mapset = MapSet.new(used)
      
      new_overlaps = MapSet.intersection(used_mapset, coords_mapset)
      { used ++ coords, overlaps ++ MapSet.to_list(new_overlaps) }
    end)
    
    MapSet.new(overlaps) |> MapSet.to_list |> length()
  end

  def part2(args) do
  end
end
