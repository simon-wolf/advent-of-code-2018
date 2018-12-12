defmodule AdventOfCode2018.Day11 do
  @moduledoc false

  @doc """
  --- Day 11: Chronal Charge ---

  You watch the Elves and their sleigh fade into the distance as they head 
  toward the North Pole.

  Actually, you're the one fading. The falling sensation returns.

  The low fuel warning light is illuminated on your wrist-mounted device. 
  Tapping it once causes it to project a hologram of the situation: a 300x300 
  grid of fuel cells and their current power levels, some negative. You're not 
  sure what negative power means in the context of time travel, but it can't 
  be good.

  Each fuel cell has a coordinate ranging from 1 to 300 in both the X 
  (horizontal) and Y (vertical) direction. In X,Y notation, the top-left cell 
  is 1,1, and the top-right cell is 300,1.

  The interface lets you select any 3x3 square of fuel cells. To increase your 
  chances of getting to your destination, you decide to choose the 3x3 square 
  with the largest total power.

  The power level in a given fuel cell can be found through the following 
  process:

  - Find the fuel cell's rack ID, which is its X coordinate plus 10.
  - Begin with a power level of the rack ID times the Y coordinate.
  - Increase the power level by the value of the grid serial number (your 
    puzzle input).
  - Set the power level to itself multiplied by the rack ID.
  - Keep only the hundreds digit of the power level (so 12345 becomes 3; 
    numbers with no hundreds digit become 0).
  - Subtract 5 from the power level.

  For example, to find the power level of the fuel cell at 3,5 in a grid 
  with serial number 8:

  - The rack ID is 3 + 10 = 13.
  - The power level starts at 13 * 5 = 65.
  - Adding the serial number produces 65 + 8 = 73.
  - Multiplying by the rack ID produces 73 * 13 = 949.
  - The hundreds digit of 949 is 9.
  - Subtracting 5 produces 9 - 5 = 4.
  
  So, the power level of this fuel cell is 4.

  Here are some more example power levels:

  - Fuel cell at  122,79, grid serial number 57: power level -5.
  - Fuel cell at 217,196, grid serial number 39: power level  0.
  - Fuel cell at 101,153, grid serial number 71: power level  4.

  Your goal is to find the 3x3 square which has the largest total power. The 
  square must be entirely within the 300x300 grid. Identify this square using 
  the X,Y coordinate of its top-left fuel cell. For example:

  For grid serial number 18, the largest total 3x3 square has a top-left 
  corner of 33,45 (with a total power of 29); these fuel cells appear in the 
  middle of this 5x5 region:

  -2  -4   4   4   4
  -4   4   4   4  -5
   4   3   3   4  -4
   1   1   2   4  -3
  -1   0   2  -5  -2

  For grid serial number 42, the largest 3x3 square's top-left is 21,61 (with 
  a total power of 30); they are in the middle of this region:

  -3   4   2   2   2
  -4   4   3   3   4
  -5   3   3   4  -4
   4   3   3   4  -3
   3   3   3  -5  -1

  What is the X,Y coordinate of the top-left fuel cell of the 3x3 square with 
  the largest total power?
  """
  def part1(serial_number) do
    get_best_square(serial_number, 3, 3)
  end


  @doc """
  You discover a dial on the side of the device; it seems to let you select a 
  square of any size, not just 3x3. Sizes from 1x1 to 300x300 are supported.

  Realizing this, you now must find the square of any size with the largest 
  total power. Identify this square by including its size as a third parameter 
  after the top-left coordinate: a 9x9 square with a top-left corner of 3,5 is 
  identified as 3,5,9.

  For example:

  - For grid serial number 18, the largest total square (with a total power of 
    113) is 16x16 and has a top-left corner of 90,269, so its identifier is 
    90,269,16.
  - For grid serial number 42, the largest total square (with a total power of 
    119) is 12x12 and has a top-left corner of 232,251, so its identifier is 
    232,251,12.

  What is the X,Y,size identifier of the square with the largest total power?
  """
  def part2(serial_number) do
    get_best_square(serial_number, 1, 300)
  end

  defp get_best_square(serial_number, grid_min_size, grid_max_size) do
    grid = build_grid(serial_number)
    summed_area_table = build_summed_area_table(grid)

    Enum.reduce(grid_min_size..grid_max_size, {{0, 0}, 0, 0}, fn size, acc ->
      Enum.reduce(1..300 - size + 1, acc, fn x, acc -> 
        Enum.reduce(1..300 - size + 1, acc, fn y, {{best_x, best_y}, best_size, best_total} -> 
          total = get_area_total(summed_area_table, x, y, size)

          if total > best_total do
            {{x, y}, size, total}
          else
            {{best_x, best_y}, best_size, best_total}
          end
        end)
      end)
    end)
  end

  defp get_area_total(summed_area_table, x, y, size) do
    top_left = Map.get(summed_area_table, {x - 1, y - 1}, 0)
    bottom_right = Map.get(summed_area_table, {x + size - 1, y + size - 1}, 0)
    top_right = Map.get(summed_area_table, {x + size - 1, y - 1}, 0)
    bottom_left = Map.get(summed_area_table, {x - 1, y + size - 1}, 0)
    
    top_left + bottom_right - top_right - bottom_left
  end

  defp build_grid(serial_number) do
    Enum.reduce(1..300, %{}, fn x, acc -> 
      Enum.reduce(1..300, acc, fn y, acc -> 
        Map.put(acc, {x, y}, cell_power_level({x, y}, serial_number))
      end)
    end)
  end

  defp cell_power_level({x, y}, serial_number) do
    rack_id = x + 10

    power_level = rack_id * y
    power_level = power_level + serial_number
    power_level = power_level * rack_id

    power_level = if power_level > 99 do
      Integer.to_string(power_level)
      |> String.slice(-3, 1)
      |> String.to_integer()
    else
      0
    end

    power_level - 5
  end

  defp build_summed_area_table(grid) do
    Enum.reduce(1..300, %{}, fn x, acc -> 
      Enum.reduce(1..300, acc, fn y, acc -> 
        summed_area(acc, grid, x, y)
      end)
    end)
  end

  defp summed_area(new_grid, base_grid, 1, 1) do
    Map.put(new_grid, {1, 1}, Map.get(base_grid, {1, 1}))
  end

  defp summed_area(new_grid, base_grid, x, 1) do
    Map.put(new_grid, {x, 1}, Map.get(base_grid, {x, 1}) + Map.get(new_grid, {x - 1, 1}))
  end

  defp summed_area(new_grid, base_grid, 1, y) do
    Map.put(new_grid, {1, y}, Map.get(base_grid, {1, y}) + Map.get(new_grid, {1, y - 1}))
  end

  defp summed_area(new_grid, base_grid, x, y) do
    base = Map.get(new_grid, {x - 1, y - 1})
    previous_x = Map.get(new_grid, {x - 1, y}) - base
    previous_y = Map.get(new_grid, {x, y - 1}) - base
    value = Map.get(base_grid, {x, y})

    Map.put(new_grid, {x, y}, base + previous_x + previous_y + value)
  end

end
