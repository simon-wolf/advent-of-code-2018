defmodule StarInfo do
  defstruct position_x: 0, position_y: 0, velocity_x: 0, velocity_y: 0
end

defmodule AdventOfCode2018.Day10 do
  @moduledoc false

  @doc """
--- Day 10: The Stars Align ---

  It's no use; your navigation system simply isn't capable of providing walking
  directions in the arctic circle, and certainly not in 1018.

  The Elves suggest an alternative. In times like these, North Pole rescue
  operations will arrange points of light in the sky to guide missing Elves
  back to base. Unfortunately, the message is easy to miss: the points move
  slowly enough that it takes hours to align them, but have so much momentum
  that they only stay aligned for a second. If you blink at the wrong time, it
  might be hours before another message appears.

  You can see these points of light floating in the distance, and record their
  position in the sky and their velocity, the relative change in position per
  second (your puzzle input). The coordinates are all given from your
  perspective; given enough time, those positions and velocities will move the
  points into a cohesive message!

  Rather than wait, you decide to fast-forward the process and calculate what
  the points will eventually spell.

  For example, suppose you note the following points:

  position=< 9,  1> velocity=< 0,  2>
  position=< 7,  0> velocity=<-1,  0>
  position=< 3, -2> velocity=<-1,  1>
  position=< 6, 10> velocity=<-2, -1>
  position=< 2, -4> velocity=< 2,  2>
  position=<-6, 10> velocity=< 2, -2>
  position=< 1,  8> velocity=< 1, -1>
  position=< 1,  7> velocity=< 1,  0>
  position=<-3, 11> velocity=< 1, -2>
  position=< 7,  6> velocity=<-1, -1>
  position=<-2,  3> velocity=< 1,  0>
  position=<-4,  3> velocity=< 2,  0>
  position=<10, -3> velocity=<-1,  1>
  position=< 5, 11> velocity=< 1, -2>
  position=< 4,  7> velocity=< 0, -1>
  position=< 8, -2> velocity=< 0,  1>
  position=<15,  0> velocity=<-2,  0>
  position=< 1,  6> velocity=< 1,  0>
  position=< 8,  9> velocity=< 0, -1>
  position=< 3,  3> velocity=<-1,  1>
  position=< 0,  5> velocity=< 0, -1>
  position=<-2,  2> velocity=< 2,  0>
  position=< 5, -2> velocity=< 1,  2>
  position=< 1,  4> velocity=< 2,  1>
  position=<-2,  7> velocity=< 2, -2>
  position=< 3,  6> velocity=<-1, -1>
  position=< 5,  0> velocity=< 1,  0>
  position=<-6,  0> velocity=< 2,  0>
  position=< 5,  9> velocity=< 1, -2>
  position=<14,  7> velocity=<-2,  0>
  position=<-3,  6> velocity=< 2, -1>

  Each line represents one point. Positions are given as <X, Y> pairs:
  X represents how far left (negative) or right (positive) the point appears,
  while Y represents how far up (negative) or down (positive) the point appears.

  At 0 seconds, each point has the position given. Each second, each point's
  velocity is added to its position. So, a point with velocity <1, -2> is
  moving to the right, but is moving upward twice as quickly. If this point's
  initial position were <3, 9>, after 3 seconds, its position would become
  <6, 3>.

  Over time, the points listed above would move like this:

  Initially:
  ........#.............
  ................#.....
  .........#.#..#.......
  ......................
  #..........#.#.......#
  ...............#......
  ....#.................
  ..#.#....#............
  .......#..............
  ......#...............
  ...#...#.#...#........
  ....#..#..#.........#.
  .......#..............
  ...........#..#.......
  #...........#.........
  ...#.......#..........

  After 1 second:
  ......................
  ......................
  ..........#....#......
  ........#.....#.......
  ..#.........#......#..
  ......................
  ......#...............
  ....##.........#......
  ......#.#.............
  .....##.##..#.........
  ........#.#...........
  ........#...#.....#...
  ..#...........#.......
  ....#.....#.#.........
  ......................
  ......................

  After 2 seconds:
  ......................
  ......................
  ......................
  ..............#.......
  ....#..#...####..#....
  ......................
  ........#....#........
  ......#.#.............
  .......#...#..........
  .......#..#..#.#......
  ....#....#.#..........
  .....#...#...##.#.....
  ........#.............
  ......................
  ......................
  ......................

  After 3 seconds:
  ......................
  ......................
  ......................
  ......................
  ......#...#..###......
  ......#...#...#.......
  ......#...#...#.......
  ......#####...#.......
  ......#...#...#.......
  ......#...#...#.......
  ......#...#...#.......
  ......#...#..###......
  ......................
  ......................
  ......................
  ......................

  After 4 seconds:
  ......................
  ......................
  ......................
  ............#.........
  ........##...#.#......
  ......#.....#..#......
  .....#..##.##.#.......
  .......##.#....#......
  ...........#....#.....
  ..............#.......
  ....#......#...#......
  .....#.....##.........
  ...............#......
  ...............#......
  ......................
  ......................

  After 3 seconds, the message appeared briefly: HI. Of course, your message
  will be much longer and will take many more seconds to appear.

  What message will eventually appear in the sky?
  """
  def part1(file_path) do
    seconds = file_path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&parse_position/1)
    |> Enum.to_list()
    |> step_forwards(0)

    result = "Took " <> Integer.to_string(seconds) <> " seconds."
    result
  end

  @doc """
  Good thing you didn't have to wait, because that would have taken a long
  time - much longer than the 3 seconds in the example above.

  Impressed by your sub-hour communication capabilities, the Elves are curious:
  exactly how many seconds would they have needed to wait for that message to
  appear?
  """
  def part2(file_path) do
    part1(file_path)
  end

  defp parse_position(position_string) do
    [positions, velocities] = position_string
    |> String.replace_prefix("position=<", "")
    |> String.replace_suffix(">", "")
    |> String.split("> velocity=<", trim: true)

    [position_x, position_y] = String.split(positions, ",", trim: true)
    [velocity_x, velocity_y] = String.split(velocities, ",", trim: true)

    %StarInfo{
      position_x: String.trim(position_x) |> String.to_integer(),
      position_y: String.trim(position_y) |> String.to_integer(),
      velocity_x: String.trim(velocity_x) |> String.to_integer(),
      velocity_y: String.trim(velocity_y) |> String.to_integer(),
    }
  end

  defp update_positions(stars_info, steps) do
    Enum.reduce(stars_info, [], fn star_info, acc ->
      new_star_info = %StarInfo{
        position_x: star_info.position_x + (star_info.velocity_x * steps),
        position_y: star_info.position_y + (star_info.velocity_y * steps),
        velocity_x: star_info.velocity_x,
        velocity_y: star_info.velocity_y
      }

      [ new_star_info ] ++ acc
    end)
  end

  defp draw_grid(positions) do
    {{min_x, min_y}, {max_x, max_y}, _} = grid_outer_bounds(positions)

    for y <- min_y..max_y do
      for x <- min_x..max_x do
        Enum.reduce_while(positions, ".", fn star_info, _acc ->
          if star_info.position_x == x and star_info.position_y == y, do: {:halt, "#"}, else: {:cont, "."}
        end)
        |> IO.write
      end

      IO.write("\n")
    end
  end

  defp grid_outer_bounds(positions) do
    {min_x, max_x} = Enum.min_max(Enum.map(positions, fn x -> x.position_x end))
    {min_y, max_y} = Enum.min_max(Enum.map(positions, fn x -> x.position_y end))
    area = abs(max_x - min_x) + abs(max_y - min_y)
    {{min_x, min_y}, {max_x, max_y}, area}
  end

  defp step_forwards(stars_info, number_of_steps) do
    {{_, _}, {_, _}, current_area} = grid_outer_bounds(stars_info)

    new_stars_info = update_positions(stars_info, 1)
    {{_, _}, {_, _}, new_area} = grid_outer_bounds(new_stars_info)

    if new_area > current_area do
      draw_grid(stars_info)
      number_of_steps
    else
      step_forwards(new_stars_info, number_of_steps + 1)
    end
  end

end
