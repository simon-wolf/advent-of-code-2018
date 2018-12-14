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
    {_, track_elements, carts_info} = file_path
    |> File.stream!()
    |> Enum.to_list()
    |> Enum.reduce({ {0, 0}, %{}, %{} }, fn file_line, { {col_index, row_index}, track_elements, carts_info} = acc ->

      { _, track_elements, carts_info} = String.graphemes(file_line)
      |> Enum.reduce(acc, fn character, { {col_index, row_index}, track_elements, carts_info} = acc ->

        new_track_elements = if character != "" do
          Map.put(track_elements, {col_index, row_index}, character)
        else
          track_elements
        end

        new_carts_info = case character do
          "<" -> Map.put(carts_info, {col_index, row_index}, {:left, :junction_go_left})
          "^" -> Map.put(carts_info, {col_index, row_index}, {:up, :junction_go_left})
          ">" -> Map.put(carts_info, {col_index, row_index}, {:right, :junction_go_left})
          "v" -> Map.put(carts_info, {col_index, row_index}, {:down, :junction_go_left})
          _ -> carts_info
        end

        { {col_index + 1, row_index}, new_track_elements, new_carts_info }
      end)

      { {0, row_index + 1}, track_elements, carts_info}
    end)

    {x, y, tick} = move_carts(1, track_elements, carts_info)
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
  def part2(args) do
  end



  defp move_carts(tick, track_elements, carts_info) do
    sorted_cart_keys = sorted_cart_identifiers(carts_info)
    
    {{x, y, crash}, carts_info} = Enum.reduce_while(sorted_cart_keys, {{0, 0, false}, carts_info}, fn {x, y}, {_, carts_info} = acc ->
      {direction, next_turn_direction} = Map.get(carts_info, {x, y})
      {new_x, new_y} = case direction do
        :left -> {x - 1, y}
        :up -> {x, y - 1}
        :right -> {x + 1, y}
        :down -> {x, y + 1}
        _ -> {x, y}
      end

      # Check if the move will cause a crash
      if Map.has_key?(carts_info, {new_x, new_y}) == true do
        {:halt, {{new_x, new_y, true}, carts_info}}
      else
        # Remove the original cart position
        carts_info = Map.delete(carts_info, {x, y})

        track_element_character = Map.get(track_elements, {new_x, new_y})

        carts_info = case track_element_character do
          "-" ->
            Map.put(carts_info, {new_x, new_y}, {direction, next_turn_direction})
          "|" ->
            Map.put(carts_info, {new_x, new_y}, {direction, next_turn_direction})
          "/" ->
            new_direction = case direction do
              :left -> :down
              :up -> :right
              :right -> :up
              :down -> :left
              _ -> direction
            end
            Map.put(carts_info, {new_x, new_y}, {new_direction, next_turn_direction})
          "\\" ->
            new_direction = case direction do
              :left -> :up
              :up -> :left
              :right -> :down
              :down -> :right
              _ -> direction
            end
            Map.put(carts_info, {new_x, new_y}, {new_direction, next_turn_direction})
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
            Map.put(carts_info, {new_x, new_y}, {new_direction, new_next_turn_direction})
          ">" ->
            Map.put(carts_info, {new_x, new_y}, {direction, next_turn_direction})
          "<" ->
            Map.put(carts_info, {new_x, new_y}, {direction, next_turn_direction})
          "^" ->
            Map.put(carts_info, {new_x, new_y}, {direction, next_turn_direction})
          "v" ->
            Map.put(carts_info, {new_x, new_y}, {direction, next_turn_direction})
          _ ->
            IO.puts "INVALID CHARACTER: =" <> track_element_character <> "= @ " <> Integer.to_string(new_x) <> ", " <> Integer.to_string(new_y)
            Map.put(carts_info, {new_x, new_y}, {direction, next_turn_direction})
        end

        {:cont, {{0, 0, false}, carts_info}}
      end
    end)

    if crash == true do
      {x, y, tick}
    else
      # Failsafe to catch infinite looping
      if tick > 1_000_000 do
        {-1, -1, -1}
      else
        move_carts(tick + 1, track_elements, carts_info)
      end
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
