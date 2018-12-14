defmodule AdventOfCode2018.Day13 do
  @moduledoc false

  @doc """
  --- Day 13: Mine Cart Madness ---

  A crop of this size requires significant logistics to transport produce, 
  soil, fertilizer, and so on. The Elves are very busy pushing things around 
  in carts on some kind of rudimentary system of tracks they've come up with.

  Seeing as how cart-and-track systems don't appear in recorded history for 
  another 1000 years, the Elves seem to be making this up as they go along. 
  They haven't even figured out how to avoid collisions yet.

  You map out the tracks (your puzzle input) and see where you can help.

  Tracks consist of straight paths (| and -), curves (/ and \), and 
  intersections (+). Curves connect exactly two perpendicular pieces of track; 
  for example, this is a closed loop:

  /----\
  |    |
  |    |
  \----/

  Intersections occur when two perpendicular paths cross. At an intersection, 
  a cart is capable of turning left, turning right, or continuing straight. 
  Here are two loops connected by two intersections:

  /-----\
  |     |
  |  /--+--\
  |  |  |  |
  \--+--/  |
     |     |
     \-----/

  Several carts are also on the tracks. Carts always face either up (^), down 
  (v), left (<), or right (>). (On your initial map, the track under each cart 
  is a straight path matching the direction the cart is facing.)

  Each time a cart has the option to turn (by arriving at any intersection), it 
  turns left the first time, goes straight the second time, turns right the 
  third time, and then repeats those directions starting again with left the 
  fourth time, straight the fifth time, and so on. This process is independent 
  of the particular intersection at which the cart has arrived - that is, the 
  cart has no per-intersection memory.

  Carts all move at the same speed; they take turns moving a single step at a 
  time. They do this based on their current location: carts on the top row move 
  first (acting from left to right), then carts on the second row move (again 
  from left to right), then carts on the third row, and so on. Once each cart 
  has moved one step, the process repeats; each of these loops is called a tick.

  For example, suppose there are two carts on a straight track:

  |  |  |  |  |
  v  |  |  |  |
  |  v  v  |  |
  |  |  |  v  X
  |  |  ^  ^  |
  ^  ^  |  |  |
  |  |  |  |  |

  First, the top cart moves. It is facing down (v), so it moves down one 
  square. Second, the bottom cart moves. It is facing up (^), so it moves up 
  one square. Because all carts have moved, the first tick ends. Then, the 
  process repeats, starting with the first cart. The first cart moves down, 
  then the second cart moves up - right into the first cart, colliding with 
  it! (The location of the crash is marked with an X.) This ends the second 
  and last tick.

  Here is a longer example:

  /->-\        
  |   |  /----\
  | /-+--+-\  |
  | | |  | v  |
  \-+-/  \-+--/
    \------/   

  /-->\        
  |   |  /----\
  | /-+--+-\  |
  | | |  | |  |
  \-+-/  \->--/
    \------/   

  /---v        
  |   |  /----\
  | /-+--+-\  |
  | | |  | |  |
  \-+-/  \-+>-/
    \------/   

  /---\        
  |   v  /----\
  | /-+--+-\  |
  | | |  | |  |
  \-+-/  \-+->/
    \------/   

  /---\        
  |   |  /----\
  | /->--+-\  |
  | | |  | |  |
  \-+-/  \-+--^
    \------/   

  /---\        
  |   |  /----\
  | /-+>-+-\  |
  | | |  | |  ^
  \-+-/  \-+--/
    \------/   

  /---\        
  |   |  /----\
  | /-+->+-\  ^
  | | |  | |  |
  \-+-/  \-+--/
    \------/   

  /---\        
  |   |  /----<
  | /-+-->-\  |
  | | |  | |  |
  \-+-/  \-+--/
    \------/   

  /---\        
  |   |  /---<\
  | /-+--+>\  |
  | | |  | |  |
  \-+-/  \-+--/
    \------/   

  /---\        
  |   |  /--<-\
  | /-+--+-v  |
  | | |  | |  |
  \-+-/  \-+--/
    \------/   

  /---\        
  |   |  /-<--\
  | /-+--+-\  |
  | | |  | v  |
  \-+-/  \-+--/
    \------/   

  /---\        
  |   |  /<---\
  | /-+--+-\  |
  | | |  | |  |
  \-+-/  \-<--/
    \------/   

  /---\        
  |   |  v----\
  | /-+--+-\  |
  | | |  | |  |
  \-+-/  \<+--/
    \------/   

  /---\        
  |   |  /----\
  | /-+--v-\  |
  | | |  | |  |
  \-+-/  ^-+--/
    \------/   

  /---\        
  |   |  /----\
  | /-+--+-\  |
  | | |  X |  |
  \-+-/  \-+--/
    \------/   

  After following their respective paths for a while, the carts eventually 
  crash. To help prevent crashes, you'd like to know the location of the first 
  crash. Locations are given in X,Y coordinates, where the furthest left 
  column is X=0 and the furthest top row is Y=0:

            111
  0123456789012
  0/---\        
  1|   |  /----\
  2| /-+--+-\  |
  3| | |  X |  |
  4\-+-/  \-+--/
  5  \------/   

  In this example, the location of the first crash is 7,3.
  """
  def part1(file_path) do
    {track_elements, carts_info} = parse_data_file(file_path)

    {x, y} = move_carts_until_crash(track_elements, carts_info)
  end

  @doc """
  There isn't much you can do to prevent crashes in this ridiculous system. 
  However, by predicting the crashes, the Elves know where to be in advance 
  and instantly remove the two crashing carts the moment any crash occurs.

  They can proceed like this for a while, but eventually, they're going to run 
  out of carts. It could be useful to figure out where the last cart that 
  hasn't crashed will end up.

  For example:

  />-<\  
  |   |  
  | /<+-\
  | | | v
  \>+</ |
    |   ^
    \<->/

  /---\  
  |   |  
  | v-+-\
  | | | |
  \-+-/ |
    |   |
    ^---^

  /---\  
  |   |  
  | /-+-\
  | v | |
  \-+-/ |
    ^   ^
    \---/

  /---\  
  |   |  
  | /-+-\
  | | | |
  \-+-/ ^
    |   |
    \---/

  After four very expensive crashes, a tick ends with only one cart remaining; 
  its final location is 6,4.

  What is the location of the last cart at the end of the first tick where it 
  is the only cart left?
  """
  def part2(file_path) do
    {track_elements, carts_info} = parse_data_file(file_path)

    {x, y} = move_carts_ignoring_crashes(track_elements, carts_info)
  end

  # Create two maps; one containing the track elements and the other 
  # information about the carts. Merge in the per-line maps.
  defp parse_data_file(file_path) do
    lines_map = map_file_lines(file_path)

    Enum.reduce(Map.keys(lines_map), {%{}, %{}}, fn line_index, {track_elements, carts_info} ->
      {new_track_elements, new_carts_info} = parse_map_line(Map.get(lines_map, line_index), line_index)
      {Map.merge(track_elements, new_track_elements), Map.merge(carts_info, new_carts_info)}
    end)
  end

  # Turn the file lines into a map where the key is the line index and the 
  # value is the line string. The line strings are tail trimmed to remove
  # whitespace and newline characters
  defp map_file_lines(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Enum.to_list()
    |> Enum.reduce(%{}, fn file_line, acc ->
      Map.put(acc, map_size(acc), file_line)
    end)
  end

  # Enumerate through the graphemes in each line string and update the 
  # per-line information maps
  defp parse_map_line(line_string, line_index) do
    characters = String.graphemes(line_string)

    Enum.reduce(0..length(characters), {%{}, %{}}, fn character_index, {track_elements, carts_info}->
      String.slice(line_string, character_index, 1)
      |> parse_map_character(character_index, line_index, track_elements, carts_info)
    end)
  end

  # Ignore whitespace and zero-length strings. Update both maps if the 
  # character represents a cart and just update the track map for all other 
  # characters
  defp parse_map_character(" ", _x, _y, track_elements, carts_info), do: {track_elements, carts_info}
  defp parse_map_character("", _x, _y, track_elements, carts_info), do: {track_elements, carts_info}
  defp parse_map_character("<" = character, x, y, track_elements, carts_info), do: {Map.put(track_elements, {x, y}, "-"), Map.put(carts_info, {x, y}, {:left, :junction_go_left})}
  defp parse_map_character(">" = character, x, y, track_elements, carts_info), do: {Map.put(track_elements, {x, y}, "-"), Map.put(carts_info, {x, y}, {:right, :junction_go_left})}
  defp parse_map_character("^" = character, x, y, track_elements, carts_info), do: {Map.put(track_elements, {x, y}, "|"), Map.put(carts_info, {x, y}, {:up, :junction_go_left})}
  defp parse_map_character("v" = character, x, y, track_elements, carts_info), do: {Map.put(track_elements, {x, y}, "|"), Map.put(carts_info, {x, y}, {:down, :junction_go_left})}
  defp parse_map_character(character, x, y, track_elements, carts_info), do: {Map.put(track_elements, {x, y}, character), carts_info}

  defp move_carts_until_crash(track_elements, carts_info) do
    sorted_cart_keys = sorted_cart_identifiers(carts_info)

    case first_crash_in_tick(sorted_cart_keys, carts_info) do
      {_, {-1, -1}} -> 
        new_carts_info = update_cart_positions(track_elements, carts_info)
        move_carts_until_crash(track_elements, new_carts_info)
      {_, {x, y}} ->
        {x, y}
    end
  end

  defp move_carts_ignoring_crashes(track_elements, carts_info) do
    sorted_cart_keys = sorted_cart_identifiers(carts_info)

    trimmed_carts_info = crashed_carts(sorted_cart_keys, carts_info)
    |> Enum.reduce(carts_info, fn crashed_coords, acc ->
      Map.delete(acc, crashed_coords)
    end)

    new_carts_info = update_cart_positions(track_elements, trimmed_carts_info)

    # If there is only one cart left then return the key which is its
    # coordinates, otherwise carry on ticking
    if Map.keys(new_carts_info) |> length() == 1 do
      Map.keys(new_carts_info) |> List.first()
    else
      move_carts_ignoring_crashes(track_elements, new_carts_info)
    end
  end

  defp update_cart_positions(track_elements, carts_info) do
    sorted_cart_keys = sorted_cart_identifiers(carts_info)

    Enum.reduce(sorted_cart_keys, %{}, fn {x, y}, acc ->
      {new_x, new_y} = new_coords_for_cart(carts_info, {x, y})
      {direction, next_turn_direction} = Map.get(carts_info, {x, y})
      track_element_character = Map.get(track_elements, {new_x, new_y})
      
      acc = case track_element_character do
        "-" ->
          Map.put(acc, {new_x, new_y}, {direction, next_turn_direction})
        "|" ->
          Map.put(acc, {new_x, new_y}, {direction, next_turn_direction})
        "/" ->
          new_direction = case direction do
            :left -> :down
            :up -> :right
            :right -> :up
            :down -> :left
            _ -> direction
          end
          Map.put(acc, {new_x, new_y}, {new_direction, next_turn_direction})
        "\\" ->
          new_direction = case direction do
            :left -> :up
            :up -> :left
            :right -> :down
            :down -> :right
            _ -> direction
          end
          Map.put(acc, {new_x, new_y}, {new_direction, next_turn_direction})
        "+" ->
          {new_direction, new_next_turn_direction} = case {direction, next_turn_direction} do
            {:left, :junction_go_left} -> {:down, :junction_go_straight}
            {:up, :junction_go_left} -> {:left, :junction_go_straight}
            {:right, :junction_go_left} -> {:up, :junction_go_straight}
            {:down, :junction_go_left} -> {:right, :junction_go_straight}

            {:left, :junction_go_straight} -> {:left, :junction_go_right}
            {:up, :junction_go_straight} -> {:up, :junction_go_right}
            {:right, :junction_go_straight} -> {:right, :junction_go_right}
            {:down, :junction_go_straight} -> {:down, :junction_go_right}

            {:left, :junction_go_right} -> {:up, :junction_go_left}
            {:up, :junction_go_right} -> {:right, :junction_go_left}
            {:right, :junction_go_right} -> {:down, :junction_go_left}
            {:down, :junction_go_right} -> {:left, :junction_go_left}
            _ -> {direction, next_turn_direction}
          end
          Map.put(acc, {new_x, new_y}, {new_direction, new_next_turn_direction})
        ">" ->
          Map.put(acc, {new_x, new_y}, {direction, next_turn_direction})
        "<" ->
          Map.put(acc, {new_x, new_y}, {direction, next_turn_direction})
        "^" ->
          Map.put(acc, {new_x, new_y}, {direction, next_turn_direction})
        "v" ->
          Map.put(acc, {new_x, new_y}, {direction, next_turn_direction})
        _ ->
          IO.puts "INVALID CHARACTER: =" <> track_element_character <> "= @ " <> Integer.to_string(new_x) <> ", " <> Integer.to_string(new_y)
          Map.put(acc, {new_x, new_y}, {direction, next_turn_direction})
      end
    end)
  end

  # Returns x and y where crash occurs or {-1, -1} if no crash
  defp first_crash_in_tick(sorted_cart_keys, carts_info) do
    Enum.reduce_while(sorted_cart_keys, {Map.new(carts_info), {-1, -1}}, fn {x, y}, {new_carts_info, {crash_x, crash_y}} = acc ->
      {new_x, new_y} = new_coords_for_cart(carts_info, {x, y})
      {direction, next_turn_direction} = Map.get(carts_info, {x, y})

      if Map.has_key?(new_carts_info, {new_x, new_y}) == true do
        {:halt, {acc, {new_x, new_y}}}
      else
        modified_carts_info = new_carts_info
        |> Map.delete({x, y})
        |> Map.put({new_x, new_y}, {direction, next_turn_direction})

        {:cont, {modified_carts_info, {crash_x, crash_y}}}
      end
    end)
  end

  # Returns a list of cart coordinates for carts which _will_ crash.
  # These are not their new coordinates but rather their current ones at the 
  # start of the tick
  defp crashed_carts(sorted_cart_keys, carts_info) do
    # sorted_cart_keys = sorted_cart_identifiers(carts_info)

    Enum.reduce(sorted_cart_keys, MapSet.new(), fn {x, y}, acc ->
      {new_x, new_y} = new_coords_for_cart(carts_info, {x, y})

      # If the acc already contains the cart's coordinates then skip it
      if MapSet.member?(acc, {x, y}) do
        acc
      else
        if Map.has_key?(carts_info, {new_x, new_y}) == true do
          acc
          |> MapSet.put({x, y})
          |> MapSet.put({new_x, new_y})
        else
          acc
        end
      end
    end)
    |> MapSet.to_list()
  end  

  defp new_coords_for_cart(carts_info, {x, y} = cart_key) do
    {direction, _next_turn_direction} = Map.get(carts_info, cart_key)
    case direction do
      :left -> {x - 1, y}
      :up -> {x, y - 1}
      :right -> {x + 1, y}
      :down -> {x, y + 1}
      _ -> {x, y}
    end
  end

  defp sorted_cart_identifiers(carts_info) do
    Map.keys(carts_info)
    |> Enum.sort(fn {x1, y1}, {x2, y2} ->
      cond do
        y1 < y2 -> true
        y1 > y2 -> false
        x1 < x2 -> true
        true -> false
      end
    end)
  end

end
